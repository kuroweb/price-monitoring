module GraphqlSchema
  module Unions
    module Categories
      module DeleteCategory
        class DeleteCategoryResult < Base
          possible_types Objects::Categories::DeleteCategory::DeleteCategoryResultSuccessType,
                         Objects::Categories::DeleteCategory::DeleteCategoryResultErrorType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteCategoryResultSuccessType"
              Objects::Categories::DeleteCategory::DeleteCategoryResultSuccessType
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
