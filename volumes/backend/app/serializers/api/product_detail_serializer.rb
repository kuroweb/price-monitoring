module Api
  class ProductDetailSerializer
    JSON_OPTIONS = {
      include: [
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
