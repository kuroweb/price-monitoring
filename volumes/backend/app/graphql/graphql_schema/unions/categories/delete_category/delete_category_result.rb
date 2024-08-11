module GraphqlSchema
  module Unions
    module Categories
      module DeleteCategory
        class DeleteCategoryResult < Base
          possible_types Objects::Categories::DeleteCategory::DeleteCategoryResultSuccess,
                         Objects::Categories::DeleteCategory::DeleteCategoryResultErrorType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteCategoryResultSuccess"
              Objects::Categories::DeleteCategory::DeleteCategoryResultSuccess
            when "DeleteCategoryResultErrorType"
              Objects::Categories::DeleteCategory::DeleteCategoryResultErrorType
            else
              raise "Unexpected DeleteCategoryResult: #{object}"
            end
          end
        end
      end
    end
  end
end
