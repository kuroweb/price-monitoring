module GraphqlSchema
  module Unions
    module Categories
      module CreateCategory
        class CreateCategoryResult < Base
          possible_types Objects::Categories::CreateCategory::CreateCategoryResultSuccess,
                         Objects::Categories::CreateCategory::CreateCategoryResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateCategoryResultSuccess"
              Objects::Categories::CreateCategory::CreateCategoryResultSuccess
            when "CreateCategoryResultError"
              Objects::Categories::CreateCategory::CreateCategoryResultError
            else
              raise "Unexpected CreateCategoryResult: #{object}"
            end
          end
        end
      end
    end
  end
end
