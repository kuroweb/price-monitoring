module GraphqlSchema
  module Objects
    module DeleteCategory
      class DeleteCategoryResultError < Base
        implements Interfaces::ResultBase

        field :error, Unions::DeleteCategory::DeleteCategoryResultErrors, null: false
      end
    end
  end
end
