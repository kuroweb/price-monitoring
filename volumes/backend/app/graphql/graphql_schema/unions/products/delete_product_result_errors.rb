module GraphqlSchema
  module Unions
    module Products
      class DeleteProductResultErrors < Base
        possible_types Objects::Products::MutationResults::DeleteProductResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteProductResultValidationFailed"
            Objects::Products::MutationResults::DeleteProductResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
