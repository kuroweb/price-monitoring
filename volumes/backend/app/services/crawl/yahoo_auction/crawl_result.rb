# クロール結果クラス
module Crawl
  module YahooAuction
    class CrawlResult
      attr_reader :yahoo_auction_id, :name, :price, :thumbnail_url, :published

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end
      end
    end
  end
end
