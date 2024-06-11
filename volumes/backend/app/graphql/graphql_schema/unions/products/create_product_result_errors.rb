module GraphqlSchema
  module Unions
    module Products
      class CreateProductResultErrors < Base
        possible_types Objects::Products::CreateProductResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateProductResultValidationFailed"
            Objects::Products::CreateProductResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
