# NOTE: 除外設定とマッチするレコードを撤去する
module Products
  module YahooAuctionProducts
    class DeleteByCrawlSetting
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        deletable.delete_all
      end

      private

      attr_reader :product

      def deletable
        YahooAuctionProduct
          .where(product_id: product.id)
          .merge(
            price_condition
              .or(include_keywords_condition)
              .or(exclude_keywords_conditon)
          )
      end

      def price_condition
        price_range = product.yahoo_auction_crawl_setting.min_price..product.yahoo_auction_crawl_setting.max_price
        YahooAuctionProduct.where.not(price: price_range)
      end

      def include_keywords_condition
        include_keywords = product.yahoo_auction_crawl_setting.keyword.split(" ")
        return YahooAuctionProduct.none if include_keywords.blank?

        include_keywords.map do |include_keyword|
          YahooAuctionProduct.where.not("name LIKE ?", "%#{include_keyword}%")
        end.reduce(&:or)
      end

      def exclude_keywords_conditon
        exclude_keywords = product.yahoo_auction_crawl_setting
                                  .yahoo_auction_crawl_setting_exclude_keywords
                                  .where.not(keyword: nil)
                                  .pluck(:keyword)
        return YahooAuctionProduct.none if exclude_keywords.blank?

        exclude_keywords.map do |exclude_keyword|
          YahooAuctionProduct.where("name LIKE ?", "%#{exclude_keyword}%")
        end.reduce(&:or)
      end
    end
  end
end
