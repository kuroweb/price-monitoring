module GraphqlSchema
  module Unions
    module Products
      module DeleteProduct
        class DeleteProductResultErrorsUnion < Base
          possible_types Objects::Products::DeleteProduct::DeleteProductResultValidationFailedType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteProductResultValidationFailedType"
              Objects::Products::DeleteProduct::DeleteProductResultValidationFailedType
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
