# クロール結果クラス
module Crawl
  module Mercari
    class CrawlResult
      attr_reader :mercari_id, :name, :price, :thumbnail_url, :published

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end
      end
    end
  end
end
