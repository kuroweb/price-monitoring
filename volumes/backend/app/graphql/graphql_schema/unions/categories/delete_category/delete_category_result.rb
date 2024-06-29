module GraphqlSchema
  module Unions
    module Categories
      module DeleteCategory
        class DeleteCategoryResult < Base
          possible_types Objects::Categories::DeleteCategory::DeleteCategoryResultSuccess,
                         Objects::Categories::DeleteCategory::DeleteCategoryResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteCategoryResultSuccess"
              Objects::Categories::DeleteCategory::DeleteCategoryResultSuccess
            when "DeleteCategoryResultError"
              Objects::Categories::DeleteCategory::DeleteCategoryResultError
            else
              raise "Unexpected DeleteCategoryResult: #{object}"
            end
          end
        end
      end
    end
  end
end
