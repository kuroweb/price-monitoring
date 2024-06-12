module GraphqlSchema
  module Unions
    module Products
      class UpdateProductResult < Base
        possible_types Objects::Products::UpdateProductResultSuccess, Objects::Products::UpdateProductResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateProductResultSuccess"
            Objects::Products::UpdateProductResultSuccess
          when "UpdateProductResultError"
            Objects::Products::UpdateProductResultError
          else
            raise "Unexpected UpdateProductResult: #{object}"
          end
        end
      end
    end
  end
end
