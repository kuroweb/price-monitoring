module GraphqlSchema
  module Unions
    module Products
      class UpdateProductResultErrors < Base
        possible_types Objects::Products::MutationResults::UpdateProductResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateProductResultValidationFailed"
            Objects::Products::MutationResults::UpdateProductResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
