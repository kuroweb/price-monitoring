module GraphqlSchema
  module Unions
    module CreateCategory
      class CreateCategoryResult < Base
        possible_types Objects::CreateCategory::CreateCategoryResultSuccess,
                       Objects::CreateCategory::CreateCategoryResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateCategoryResultSuccess"
            Objects::CreateCategory::CreateCategoryResultSuccess
          when "CreateCategoryResultError"
            Objects::CreateCategory::CreateCategoryResultError
          else
            raise "Unexpected CreateCategoryResult: #{object}"
          end
        end
      end
    end
  end
end
