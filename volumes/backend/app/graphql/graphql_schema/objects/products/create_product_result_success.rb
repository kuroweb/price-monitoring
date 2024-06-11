module GraphqlSchema
  module Objects
    module Products
      class CreateProductResultSuccess < Base
        implements Interfaces::Products::ResultBase

        field :product, Product, null: false
      end
    end
  end
end
