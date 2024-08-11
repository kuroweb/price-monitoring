module GraphqlSchema
  module Objects
    module Products
      module CreateProduct
        class CreateProductResultValidationFailed < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
