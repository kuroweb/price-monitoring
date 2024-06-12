module GraphqlSchema
  module Unions
    module Products
      class DeleteProductResult < Base
        possible_types Objects::Products::MutationResults::DeleteProductResultSuccess,
                       Objects::Products::MutationResults::DeleteProductResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteProductResultSuccess"
            Objects::Products::MutationResults::DeleteProductResultSuccess
          when "DeleteProductResultError"
            Objects::Products::MutationResults::DeleteProductResultError
          else
            raise "Unexpected DeleteProductResult: #{object}"
          end
        end
      end
    end
  end
end
