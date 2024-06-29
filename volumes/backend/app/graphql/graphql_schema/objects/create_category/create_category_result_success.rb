module GraphqlSchema
  module Objects
    module CreateCategory
      class CreateCategoryResultSuccess < Base
        implements Interfaces::ResultBase

        field :category, Objects::Category, null: false
      end
    end
  end
end
