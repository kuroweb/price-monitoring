module GraphqlSchema
  module Objects
    module Products
      module CreateProduct
        class CreateProductResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
