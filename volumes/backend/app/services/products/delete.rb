module Products
  class Delete
    def self.call(...)
      new(...).call
    end

    def initialize(product:)
      @product = product
    end

    def call
      product.destroy
      ServiceResponse.success
    rescue StandardError => e
      ServiceResponse.error(message: e.message)
    end

    private

    attr_reader :product
  end
end
