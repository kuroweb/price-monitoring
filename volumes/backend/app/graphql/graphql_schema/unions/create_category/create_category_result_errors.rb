module GraphqlSchema
  module Unions
    module CreateCategory
      class CreateCategoryResultErrors < Base
        possible_types Objects::CreateCategory::CreateCategoryResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateCategoryResultValidationFailed"
            Objects::CreateCategory::CreateCategoryResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
