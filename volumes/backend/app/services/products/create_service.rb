module Products
  class CreateService
    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @params = params
    end

    def call
      product = Product.new(params)

      if product.save
        ServiceResponse.success(payload: { product: })
      else
        ServiceResponse.error(message: "#{self.class.name} is failed.", status: 400)
      end
    end

    private

    attr_reader :params
  end
end
