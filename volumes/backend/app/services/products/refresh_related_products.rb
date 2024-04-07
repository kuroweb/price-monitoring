module Products
  class RefreshRelatedProducts
    def self.call(...)
      new(...).call
    end

    def initialize(product:)
      @product = product
    end

    def call
      ApplicationRecord.transaction do
        delete_mercari_products
        delete_yahoo_auction_products
        delete_yahoo_fleamarket_products
      end
    end

    private

    attr_reader :product

    def delete_mercari_products
      Products::MercariProducts::DeleteByCrawlSetting.call(product:)
    end

    def delete_yahoo_auction_products
      Products::YahooAuctionProducts::DeleteByCrawlSetting.call(product:)
    end

    def delete_yahoo_fleamarket_products
      Products::YahooFleamarketProducts::DeleteByCrawlSetting.call(product:)
    end
  end
end
