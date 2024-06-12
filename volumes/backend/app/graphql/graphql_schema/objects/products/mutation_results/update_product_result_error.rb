module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class UpdateProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::UpdateProductResultErrors, null: false
        end
      end
    end
  end
end
