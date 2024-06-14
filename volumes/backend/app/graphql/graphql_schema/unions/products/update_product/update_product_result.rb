module GraphqlSchema
  module Unions
    module Products
      module UpdateProduct
        class UpdateProductResult < Base
          possible_types Objects::Products::UpdateProduct::UpdateProductResultSuccess,
                         Objects::Products::UpdateProduct::UpdateProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateProductResultSuccess"
              Objects::Products::UpdateProduct::UpdateProductResultSuccess
            when "UpdateProductResultError"
              Objects::Products::UpdateProduct::UpdateProductResultError
            else
              raise "Unexpected UpdateProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
