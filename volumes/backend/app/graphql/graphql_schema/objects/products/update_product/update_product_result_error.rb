module GraphqlSchema
  module Objects
    module Products
      module UpdateProduct
        class UpdateProductResultError < Base
          implements Interfaces::ResultBase

          field :error, Unions::Products::UpdateProduct::UpdateProductResultErrors, null: false
        end
      end
    end
  end
end
