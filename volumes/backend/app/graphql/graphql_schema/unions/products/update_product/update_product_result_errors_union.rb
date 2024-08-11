module GraphqlSchema
  module Unions
    module Products
      module UpdateProduct
        class UpdateProductResultErrorsUnion < Base
          possible_types Objects::Products::UpdateProduct::UpdateProductResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateProductResultValidationFailed"
              Objects::Products::UpdateProduct::UpdateProductResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
