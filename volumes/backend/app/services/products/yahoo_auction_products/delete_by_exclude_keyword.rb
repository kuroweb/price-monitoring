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
        deletable
        # deletable.delete_all
      end

      private

      attr_reader :product

      def deletable
        product.yahoo_auction_products.merge(or_conditions)
      end

      def or_conditions
        price_condition.or(exclude_keywords_conditon)
                       .or(exclude_yahoo_auction_id_condition)
                       .or(exclude_seller_id_codition)
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
        YahooAuctionProduct.where(name: exclude_keywords)
      end

      def exclude_yahoo_auction_id_condition
        ids = product.yahoo_auction_crawl_setting
                     .yahoo_auction_crawl_setting_exclude_keywords
                     .where.not(yahoo_auction_id: nil)
                     .pluck(:yahoo_auction_id)
        YahooAuctionProduct.where(yahoo_auction_id: ids)
      end

      def exclude_seller_id_codition
        ids = product.yahoo_auction_crawl_setting
                     .yahoo_auction_crawl_setting_exclude_keywords
                     .where.not(seller_id: nil)
                     .pluck(:seller_id)
        YahooAuctionProduct.where(seller_id: ids)
      end
    end
  end
end
