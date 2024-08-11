module GraphqlSchema
  module Objects
    module Products
      module DeleteProduct
        class DeleteProductResultErrorType < Base
          implements Interfaces::ResultBase

          field :error, Unions::Products::DeleteProduct::DeleteProductResultErrors, null: false
        end
      end
    end
  end
end
