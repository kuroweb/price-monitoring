module GraphqlSchema
  module Objects
    module Categories
      module CreateCategory
        class CreateCategoryResultErrorType < Base
          implements Interfaces::ResultBase

          field :error, Unions::Categories::CreateCategory::CreateCategoryResultErrors, null: false
        end
      end
    end
  end
end
