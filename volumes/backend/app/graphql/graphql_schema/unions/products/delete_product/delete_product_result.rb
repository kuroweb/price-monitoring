module GraphqlSchema
  module Unions
    module Products
      module DeleteProduct
        class DeleteProductResult < Base
          possible_types Objects::Products::DeleteProduct::DeleteProductResultSuccessType,
                         Objects::Products::DeleteProduct::DeleteProductResultErrorType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteProductResultSuccessType"
              Objects::Products::DeleteProduct::DeleteProductResultSuccessType
            when "DeleteProductResultErrorType"
              Objects::Products::DeleteProduct::DeleteProductResultErrorType
            else
              raise "Unexpected DeleteProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
