module GraphqlSchema
  module Unions
    module Products
      module DeleteProduct
        class DeleteProductResult < Base
          possible_types Objects::Products::DeleteProduct::DeleteProductResultSuccess,
                         Objects::Products::DeleteProduct::DeleteProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteProductResultSuccess"
              Objects::Products::DeleteProduct::DeleteProductResultSuccess
            when "DeleteProductResultError"
              Objects::Products::DeleteProduct::DeleteProductResultError
            else
              raise "Unexpected DeleteProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
