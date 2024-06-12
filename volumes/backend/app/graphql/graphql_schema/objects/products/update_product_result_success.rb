module GraphqlSchema
  module Objects
    module Products
      class UpdateProductResultSuccess < Base
        implements Interfaces::Products::ResultBase

        field :product, Product, null: false
      end
    end
  end
end
