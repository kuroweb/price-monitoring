module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultValidationFailedType < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
