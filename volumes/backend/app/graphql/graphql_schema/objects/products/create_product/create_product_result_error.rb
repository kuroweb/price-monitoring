module GraphqlSchema
  module Objects
    module Products
      module CreateProduct
        class CreateProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::CreateProduct::CreateProductResultErrors, null: false
        end
      end
    end
  end
end
