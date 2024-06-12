module GraphqlSchema
  module Unions
    module Products
      class UpdateProductResult < Base
        possible_types Objects::Products::MutationResults::UpdateProductResultSuccess,
                       Objects::Products::MutationResults::UpdateProductResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateProductResultSuccess"
            Objects::Products::MutationResults::UpdateProductResultSuccess
          when "UpdateProductResultError"
            Objects::Products::MutationResults::UpdateProductResultError
          else
            raise "Unexpected UpdateProductResult: #{object}"
          end
        end
      end
    end
  end
end
