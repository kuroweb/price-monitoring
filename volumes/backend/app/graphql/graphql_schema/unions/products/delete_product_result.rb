module GraphqlSchema
  module Unions
    module Products
      class DeleteProductResult < Base
        possible_types Objects::Products::DeleteProductResultSuccess, Objects::Products::DeleteProductResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteProductResultSuccess"
            Objects::Products::DeleteProductResultSuccess
          when "DeleteProductResultError"
            Objects::Products::DeleteProductResultError
          else
            raise "Unexpected DeleteProductResult: #{object}"
          end
        end
      end
    end
  end
end
