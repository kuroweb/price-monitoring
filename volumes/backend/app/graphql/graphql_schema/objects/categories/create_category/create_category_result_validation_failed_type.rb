module GraphqlSchema
  module Objects
    module Categories
      module CreateCategory
        class CreateCategoryResultValidationFailedType < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
