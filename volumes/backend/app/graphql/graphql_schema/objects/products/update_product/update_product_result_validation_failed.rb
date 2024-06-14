module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultValidationFailed < Base
          implements Interfaces::Products::UserError

          # TODO: 後でネームスペースを直す
          field :details, [Objects::Products::MutationResults::ErrorDetail], null: false
        end
      end
    end
  end
end
