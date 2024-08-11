module GraphqlSchema
  module Unions
    module Products
      module CreateProduct
        class CreateProductResultErrorsUnion < Base
          possible_types Objects::Products::CreateProduct::CreateProductResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateProductResultValidationFailed"
              Objects::Products::CreateProduct::CreateProductResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
