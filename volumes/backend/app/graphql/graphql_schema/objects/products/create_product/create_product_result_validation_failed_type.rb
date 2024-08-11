module GraphqlSchema
  module Objects
    module Products
      module CreateProduct
        class CreateProductResultValidationFailedType < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
