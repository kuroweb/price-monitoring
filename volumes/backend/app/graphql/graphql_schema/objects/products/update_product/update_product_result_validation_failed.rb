module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultValidationFailed < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
