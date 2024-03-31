module Search
  class RelatedProducts
    attr_reader :products

    def initialize(products = [])
      @products = products
    end

    def add(product)
      products.push(product)
    end
  end
end
