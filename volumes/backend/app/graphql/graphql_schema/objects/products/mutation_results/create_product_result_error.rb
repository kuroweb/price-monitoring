module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class CreateProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::CreateProductResultErrors, null: false
        end
      end
    end
  end
end
