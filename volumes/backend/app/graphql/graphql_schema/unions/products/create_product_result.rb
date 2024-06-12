module GraphqlSchema
  module Unions
    module Products
      class CreateProductResult < Base
        possible_types Objects::Products::MutationResults::CreateProductResultSuccess,
                       Objects::Products::MutationResults::CreateProductResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateProductResultSuccess"
            Objects::Products::MutationResults::CreateProductResultSuccess
          when "CreateProductResultError"
            Objects::Products::MutationResults::CreateProductResultError
          else
            raise "Unexpected CreateProductResult: #{object}"
          end
        end
      end
    end
  end
end
