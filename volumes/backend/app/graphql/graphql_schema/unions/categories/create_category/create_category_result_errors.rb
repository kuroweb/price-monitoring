module GraphqlSchema
  module Unions
    module Categories
      module CreateCategory
        class CreateCategoryResultErrors < Base
          possible_types Objects::Categories::CreateCategory::CreateCategoryResultValidationFailedType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateCategoryResultValidationFailedType"
              Objects::Categories::CreateCategory::CreateCategoryResultValidationFailedType
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
