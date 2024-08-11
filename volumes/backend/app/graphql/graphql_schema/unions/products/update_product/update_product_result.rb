module GraphqlSchema
  module Unions
    module Products
      module UpdateProduct
        class UpdateProductResult < Base
          possible_types Objects::Products::UpdateProduct::UpdateProductResultSuccessType,
                         Objects::Products::UpdateProduct::UpdateProductResultErrorType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateProductResultSuccessType"
              Objects::Products::UpdateProduct::UpdateProductResultSuccessType
            when "UpdateProductResultErrorType"
              Objects::Products::UpdateProduct::UpdateProductResultErrorType
            else
              raise "Unexpected UpdateProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
