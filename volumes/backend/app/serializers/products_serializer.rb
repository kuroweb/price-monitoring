class ProductsSerializer < BaseSerializer
  attr_reader :products

  def initialize(products)
    @products = products.map do |product|
      ProductSerializer.new(product)
    end
  end

  private

  def attribute_names
    %w[products]
  end
end
