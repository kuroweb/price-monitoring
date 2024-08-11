module GraphqlSchema
  module Objects
    module Products
      module DeleteProduct
        class DeleteProductResultValidationFailedType < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
