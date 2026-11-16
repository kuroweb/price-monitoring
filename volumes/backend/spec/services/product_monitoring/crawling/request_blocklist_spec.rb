require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::RequestBlocklist do
  it "動画・広告・計測へのリクエストを止めること" do
    %w[
      https://www.youtube.com/embed/kVNsK59ytMw
      https://rr3---sn-oguelnsl.googlevideo.com/videoplayback
      https://googleads.g.doubleclick.net/pagead/id
      https://analytics.tiktok.com/i18n/pixel/events.js
    ].each do |url|
      expect(described_class.blocked?(url)).to be(true), "#{url} が止まっていません"
    end
  end

  it "検索結果と商品ページは止めないこと" do
    %w[
      https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iphone
      https://jp.mercari.com/search?keyword=iphone
      https://auctions.yahoo.co.jp/search/search?p=iphone
      https://paypayfleamarket.yahoo.co.jp/search/iphone
      https://iosys.co.jp/items?q=iphone
      https://ec.treasure-f.com/search?q=iphone
    ].each do |url|
      expect(described_class.blocked?(url)).to be(false), "#{url} が止まっています"
    end
  end
end
