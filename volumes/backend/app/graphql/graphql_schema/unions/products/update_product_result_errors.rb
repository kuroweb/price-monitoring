module GraphqlSchema
  module Unions
    module Products
      class UpdateProductResultErrors < Base
        possible_types Objects::Products::UpdateProductResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateProductResultValidationFailed"
            Objects::Products::UpdateProductResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
