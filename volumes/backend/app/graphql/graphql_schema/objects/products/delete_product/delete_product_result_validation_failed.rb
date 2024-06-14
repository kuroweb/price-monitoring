module GraphqlSchema
  module Objects
    module Products
      module DeleteProduct
        class DeleteProductResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
