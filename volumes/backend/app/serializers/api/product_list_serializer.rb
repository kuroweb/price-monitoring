module Api
  class ProductListSerializer
    JSON_OPTIONS = {
      include: [
        category: {}
      ]
    }.freeze

    PRELOAD_OPTIONS = {
      category: []
    }.freeze

    def initialize(products)
      @products = products.preload(PRELOAD_OPTIONS)
    end

    def as_json(_opts = {})
      {
        products: @products.as_json(JSON_OPTIONS)
      }
    end
  end
end
