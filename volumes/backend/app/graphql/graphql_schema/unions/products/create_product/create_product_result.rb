module GraphqlSchema
  module Unions
    module Products
      module CreateProduct
        class CreateProductResult < Base
          possible_types Objects::Products::CreateProduct::CreateProductResultSuccess,
                         Objects::Products::CreateProduct::CreateProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateProductResultSuccess"
              Objects::Products::CreateProduct::CreateProductResultSuccess
            when "CreateProductResultError"
              Objects::Products::CreateProduct::CreateProductResultError
            else
              raise "Unexpected CreateProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
