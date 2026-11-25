module Api
  class ProductDetailSerializer
    JSON_OPTIONS = {
      include: [
        {
          yahoo_auction_crawl_setting: {
            include: %i[
              yahoo_auction_crawl_setting_exclude_keywords
              yahoo_auction_crawl_setting_required_keywords
              yahoo_auction_crawl_setting_exclude_products
            ]
          }
        },
        :category
      ]
    }.freeze

    def initialize(product)
      @product = product
    end

    def as_json(_opts = {})
      @product.as_json(JSON_OPTIONS)
    end
  end
end
