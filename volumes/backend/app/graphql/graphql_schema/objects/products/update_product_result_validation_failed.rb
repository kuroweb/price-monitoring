module GraphqlSchema
  module Objects
    module Products
      class UpdateProductResultValidationFailed < Base
        implements Interfaces::Products::UserError

        field :details, [ErrorDetail], null: false
      end
    end
  end
end
