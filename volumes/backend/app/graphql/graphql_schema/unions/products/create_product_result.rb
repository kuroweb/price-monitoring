module GraphqlSchema
  module Unions
    module Products
      class CreateProductResult < Base
        possible_types Objects::Products::CreateProductResultSuccess, Objects::Products::CreateProductResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateProductResultSuccess"
            Objects::Products::CreateProductResultSuccess
          when "CreateProductResultError"
            Objects::Products::CreateProductResultError
          else
            raise "Unexpected CreateProductResult: #{object}"
          end
        end
      end
    end
  end
end
