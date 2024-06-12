module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class DeleteProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::DeleteProductResultErrors, null: false
        end
      end
    end
  end
end
