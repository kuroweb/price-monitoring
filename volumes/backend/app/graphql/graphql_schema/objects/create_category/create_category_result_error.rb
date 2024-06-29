module GraphqlSchema
  module Objects
    module CreateCategory
      class CreateCategoryResultError < Base
        implements Interfaces::ResultBase

        field :error, Unions::CreateCategory::CreateCategoryResultErrors, null: false
      end
    end
  end
end
