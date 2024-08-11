module GraphqlSchema
  module Unions
    module Categories
      module CreateCategory
        class CreateCategoryResult < Base
          possible_types Objects::Categories::CreateCategory::CreateCategoryResultSuccessType,
                         Objects::Categories::CreateCategory::CreateCategoryResultErrorType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateCategoryResultSuccessType"
              Objects::Categories::CreateCategory::CreateCategoryResultSuccessType
            when "CreateCategoryResultErrorType"
              Objects::Categories::CreateCategory::CreateCategoryResultErrorType
            else
              raise "Unexpected CreateCategoryResult: #{object}"
            end
          end
        end
      end
    end
  end
end
