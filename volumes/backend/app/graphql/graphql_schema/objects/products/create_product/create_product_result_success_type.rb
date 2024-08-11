module GraphqlSchema
  module Objects
    module Products
      module CreateProduct
        class CreateProductResultSuccessType < Base
          implements Interfaces::ResultBase

          field :product, Objects::Products::ProductType, null: false
        end
      end
    end
  end
end
