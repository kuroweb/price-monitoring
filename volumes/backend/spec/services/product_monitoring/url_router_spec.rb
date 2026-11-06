require "rails_helper"

RSpec.describe ProductMonitoring::UrlRouter do
  describe ".call" do
    it "routes supported search pages" do
      expect(described_class.call(url: "https://jp.mercari.com/search?keyword=phone")).to eq(
        platform: "mercari", canonical_url: "https://jp.mercari.com/search?keyword=phone"
      )
      expect(described_class.call(url: "https://iosys.co.jp/items?q=phone")).to eq(
        platform: "iosys", canonical_url: "https://iosys.co.jp/items?q=phone"
      )
    end

    it "rejects iosys group searches, including encoded and repeated parameters" do
      ["t=g", "q=phone&%74=%67", "t=x&t=g"].each do |query|
        expect { described_class.call(url: "https://iosys.co.jp/items?#{query}") }
          .to raise_error(ArgumentError, /個別出品.*t=gなし/)
      end
    end

    ["http://jp.mercari.com/search?q=x", "https://jp.mercari.com.evil/search?q=x",
     "https://user@jp.mercari.com/search?q=x", "https://jp.mercari.com:444/search?q=x", "https://jp.mercari.com/item/abc", "https://127.0.0.1/search?q=x"].each do |url|
      it "rejects unsafe URL #{url}" do
        expect { described_class.call(url: url) }.to raise_error(ArgumentError)
      end
    end
  end
end
