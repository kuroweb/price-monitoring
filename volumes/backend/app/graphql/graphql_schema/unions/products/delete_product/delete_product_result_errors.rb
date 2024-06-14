module GraphqlSchema
  module Unions
    module Products
      module DeleteProduct
        class DeleteProductResultErrors < Base
          possible_types Objects::Products::DeleteProduct::DeleteProductResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteProductResultValidationFailed"
              Objects::Products::DeleteProduct::DeleteProductResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
