module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultErrorType < Base
          implements Interfaces::ResultBase

          field :error, Unions::Products::UpdateProduct::UpdateProductResultErrorsUnion, null: false
        end
      end
    end
  end
end
