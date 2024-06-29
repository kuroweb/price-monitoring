module GraphqlSchema
  module Unions
    module Categories
      module DeleteCategory
        class DeleteCategoryResultErrors < Base
          possible_types Objects::Categories::DeleteCategory::DeleteCategoryResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteCategoryResultValidationFailed"
              Objects::Categories::DeleteCategory::DeleteCategoryResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
