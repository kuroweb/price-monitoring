module GraphqlSchema
  module Unions
    module Categories
      module DeleteCategory
        class DeleteCategoryResultErrorsUnion < Base
          possible_types Objects::Categories::DeleteCategory::DeleteCategoryResultValidationFailedType

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteCategoryResultValidationFailedType"
              Objects::Categories::DeleteCategory::DeleteCategoryResultValidationFailedType
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
