module GraphqlSchema
  module Unions
    module Categories
      module CreateCategory
        class CreateCategoryResultErrorsUnion < Base
          possible_types Objects::Categories::CreateCategory::CreateCategoryResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateCategoryResultValidationFailed"
              Objects::Categories::CreateCategory::CreateCategoryResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
