module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultSuccess < Base
          implements Interfaces::ResultBase

          field :product, Objects::Products::Product, null: false
        end
      end
    end
  end
end
