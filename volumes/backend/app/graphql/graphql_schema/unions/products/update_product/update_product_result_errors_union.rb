module GraphqlSchema
  module Unions
    module Products
      module UpdateProduct
        class UpdateProductResultErrorsUnion < Base
          possible_types Objects::Products::UpdateProduct::UpdateProductResultValidationFailedType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateProductResultValidationFailedType"
              Objects::Products::UpdateProduct::UpdateProductResultValidationFailedType
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
