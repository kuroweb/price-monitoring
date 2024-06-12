module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class UpdateProductResultSuccess < Base
          implements Interfaces::Products::ResultBase

          field :product, Product, null: false
        end
      end
    end
  end
end
