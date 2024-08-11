module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultSuccessType < Base
          implements Interfaces::ResultBase

          field :product, Objects::Products::Product, null: false
        end
      end
    end
  end
end
