# NOTE: 除外設定とマッチするレコードを撤去する
module Products
  module YahooAuctionProducts
    class DeleteByExcludeKeyword
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
        product.yahoo_auction_products
               .merge(price_condition.or(exclude_keywords_conditon))
      end

      def price_condition
        price_range = product.yahoo_auction_crawl_setting.min_price..product.yahoo_auction_crawl_setting.max_price
        YahooAuctionProduct.where.not(price: price_range)
      end

      def exclude_keywords_conditon
        exclude_keywords = product.yahoo_auction_crawl_setting
                                  .yahoo_auction_crawl_setting_exclude_keywords
                                  .where.not(keyword: nil)
                                  .pluck(:keyword)

        exclude_keywords.map do |exclude_keyword|
          YahooAuctionProduct.where("name LIKE ?", "%#{exclude_keyword}%")
        end.reduce(&:or)
      end
    end
  end
end
