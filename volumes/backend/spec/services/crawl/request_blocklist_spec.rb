require "rails_helper"

RSpec.describe Crawl::RequestBlocklist do
  describe ".blocked_request?" do
    it "YouTube・動画配信・広告のドメインへのリクエストをブロックする" do
      %w[
        https://www.youtube.com/embed/kVNsK59ytMw
        https://rr3---sn-oguelnsl.googlevideo.com/videoplayback
        https://googleads.g.doubleclick.net/pagead/id
      ].each do |url|
        expect(described_class.blocked_request?(url)).to be(true), "#{url} がブロックされていません"
      end
    end

    it "商品一覧や商品詳細の取得に必要なリクエストはブロックしない" do
      %w[
        https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iphone
        https://jp.mercari.com/search?keyword=iphone
        https://auctions.yahoo.co.jp/search/search?p=iphone
      ].each do |url|
        expect(described_class.blocked_request?(url)).to be(false), "#{url} がブロックされています"
      end
    end
  end
end
