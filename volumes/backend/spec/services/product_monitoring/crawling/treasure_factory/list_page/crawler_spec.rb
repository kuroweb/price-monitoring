require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::TreasureFactory::ListPage::Crawler do
  let(:url) { "https://ec.treasure-f.com/search?category=1029&word=macbook&number=90" }
  let(:setting) { create(:product_monitoring_crawl_setting, search_urls: [url]) }
  let(:visited) { [] }

  def item_html(id:, price: nil, image: %(src="/images/#{id}/340/#{id}_01.jpeg"), alt: "Apple (アップル) MacBook Air")
    price_html = price ? %(<div><p class="cm-itemlist_price is-sale">#{price}</p></div>) : ""
    soldout_html = price ? "" : '<span class="cm-itemlist_soldout"><i>SOLD OUT</i></span>'
    <<~HTML
      <li class="pj-search_item"><a class="cm-itemlist_itemcode_link" href="/item/#{id}">
      <div class="cm-itemlist_image"><img #{image} alt="#{alt}">#{soldout_html}</div>
      <div class="cm-itemlist_text_wrap"><p class="cm-itemlist_text">Apple(アップル)</p>
      <p class="cm-itemlist_text">MacBook Air</p></div>#{price_html}</a></li>
    HTML
  end

  # 渡した HTML を順に返し、最後の HTML は繰り返す
  def stub_pages(*htmls)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute) do |**, &block|
      block.call(browser_page(htmls.size > 1 ? htmls.shift : htmls.first))
    end
  end

  def browser_page(html)
    page = instance_double(Playwright::Page, content: html)
    allow(page).to receive(:goto) do |url|
      visited << url
      allow(page).to receive(:url).and_return(url)
      instance_double(Playwright::Response, status: 200)
    end
    page
  end

  it "販売中の出品だけを読み取り、次ページへ進むこと" do
    stub_pages(<<~HTML, item_html(id: "3", price: "￥1,000"))
      <ul>#{item_html(id: '1082002574368733', price: '￥68,200')}
      #{item_html(id: '1004019920556004', image: 'class="image-lazyload" data-src="/images/2.jpeg"')}</ul>
      <ul class="cm-pagination"><li><a href="https://ec.treasure-f.com/search?page=2" rel="next"></a></li></ul>
    HTML
    expect(described_class.call(crawl_setting: setting)).to contain_exactly(
      { platform: "treasure_factory", external_id: "1082002574368733", name: "Apple (アップル) MacBook Air",
        price: 68_200, sold: false, product_url: "https://ec.treasure-f.com/item/1082002574368733",
        thumbnail_url: "https://ec.treasure-f.com/images/1082002574368733/340/1082002574368733_01.jpeg" },
      include(external_id: "3")
    )
    expect(visited).to include("https://ec.treasure-f.com/search?category=1029&word=macbook&number=90&page=2")
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute).with(block_scripts: true).twice
  end

  it "遅延読み込みの画像URLを使い、代替テキストがなければ一覧の表示名を使うこと" do
    stub_pages(item_html(id: "1", price: "￥1,000", image: 'src="/dummy.gif" data-src="/images/1.jpeg"', alt: ""))
    expect(described_class.call(crawl_setting: setting).first)
      .to include(name: "Apple(アップル) MacBook Air", thumbnail_url: "https://ec.treasure-f.com/images/1.jpeg")
  end

  it "売り切れだけのページでも次ページがあれば取得を続けること" do
    next_link = '<ul class="cm-pagination"><li><a href="/search?page=2" rel="next"></a></li></ul>'
    stub_pages(item_html(id: "2") + next_link, item_html(id: "3", price: "￥1,000"))
    expect(described_class.call(crawl_setting: setting).pluck(:external_id)).to eq(["3"])
  end

  it "明示的な空結果は空とし、出品も空結果もないページは取得の失敗として記録すること" do
    stub_pages('<div class="pj-search_not_found"><h3>ご指定の条件に一致する商品がありませんでした。</h3></div>')
    expect(described_class.call(crawl_setting: setting)).to eq([])
    stub_pages("<html>challenge</html>")
    allow(Rails.logger).to receive(:warn)
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn).with(%r{\ACrawl failed for https://ec.treasure-f.com/search: })
  end
end
