module GraphqlSchema
  module Objects
    module Categories
      module DeleteCategory
        class DeleteCategoryResultErrorType < Base
          implements Interfaces::ResultBase

          field :error, Unions::Categories::DeleteCategory::DeleteCategoryResultErrors, null: false
        end
      end
    end
  end
end
