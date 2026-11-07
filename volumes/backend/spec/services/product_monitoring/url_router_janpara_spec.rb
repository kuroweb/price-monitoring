require "rails_helper"

RSpec.describe ProductMonitoring::UrlRouter do
  it "キーワードが空でない Janpara 検索だけを振り分け詳細は確認しないこと" do
    url = "https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro"
    expect(described_class.call(url: url)).to include(platform: "janpara", site: ProductMonitoring::Sites::Janpara)
    expect(described_class.detail_site("janpara")).to be_nil
    ["https://www.janpara.co.jp/sale/search/result/?KEYWORDS=+", "https://www.janpara.co.jp/sale/search/result/",
     "https://www.janpara.co.jp/sale/search/detail/?KEYWORDS=x",
     "https://janpara.co.jp/sale/search/result/?KEYWORDS=x"].each do |invalid|
      expect { described_class.call(url: invalid) }.to raise_error(ArgumentError)
    end
  end
end
