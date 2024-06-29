module GraphqlSchema
  module Unions
    module DeleteCategory
      class DeleteCategoryResult < Base
        possible_types Objects::DeleteCategory::DeleteCategoryResultSuccess,
                       Objects::DeleteCategory::DeleteCategoryResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteCategoryResultSuccess"
            Objects::DeleteCategory::DeleteCategoryResultSuccess
          when "DeleteCategoryResultError"
            Objects::DeleteCategory::DeleteCategoryResultError
          else
            raise "Unexpected DeleteCategoryResult: #{object}"
          end
        end
      end
    end
  end
end
