module GraphqlSchema
  module Unions
    module Products
      module CreateProduct
        class CreateProductResultErrors < Base
          possible_types Objects::Products::CreateProduct::CreateProductResultValidationFailedType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateProductResultValidationFailedType"
              Objects::Products::CreateProduct::CreateProductResultValidationFailedType
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
