module GraphqlSchema
  module Objects
    module Categories
      module CreateCategory
        class CreateCategoryResultSuccess < Base
          implements Interfaces::ResultBase

          field :category, Objects::Categories::Category, null: false
        end
      end
    end
  end
end
