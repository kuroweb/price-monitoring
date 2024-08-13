class RelatedProducts
  attr_reader :products

  def initialize(products = [])
    @products = products
  end

  def add(product)
    products.push(product)
  end

  def valid?
    products.all?(&:valid?)
  end

  def errors
    products.map.with_index do |product, index|
      "RelatedProduct #{index + 1}: #{product.errors.full_messages.join(', ')}" if product.invalid?
    end.compact
  end
end
