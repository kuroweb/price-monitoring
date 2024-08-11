module GraphqlSchema
  module Objects
    module Products
      module CreateProduct
        class CreateProductResultErrorType < Base
          implements Interfaces::ResultBase

          field :error, Unions::Products::CreateProduct::CreateProductResultErrorsUnion, null: false
        end
      end
    end
  end
end
