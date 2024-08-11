module GraphqlSchema
  module Unions
    module Products
      module CreateProduct
        class CreateProductResultUnion < Base
          possible_types Objects::Products::CreateProduct::CreateProductResultSuccessType,
                         Objects::Products::CreateProduct::CreateProductResultErrorType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateProductResultSuccessType"
              Objects::Products::CreateProduct::CreateProductResultSuccessType
            when "CreateProductResultErrorType"
              Objects::Products::CreateProduct::CreateProductResultErrorType
            else
              raise "Unexpected CreateProductResultUnion: #{object}"
            end
          end
        end
      end
    end
  end
end
