# クロール結果クラス
module Crawl
  module YahooAuction
    class CrawlResult
      attr_reader :platform, :external_id, :seller_id, :name, :price, :thumbnail_url, :published, :bought_date

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end
      end
    end
  end
end
