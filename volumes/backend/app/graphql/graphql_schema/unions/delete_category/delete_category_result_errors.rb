module GraphqlSchema
  module Unions
    module DeleteCategory
      class DeleteCategoryResultErrors < Base
        possible_types Objects::DeleteCategory::DeleteCategoryResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteCategoryResultValidationFailed"
            Objects::DeleteCategory::DeleteCategoryResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
