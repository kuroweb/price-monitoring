module GraphqlSchema
  module Objects
    module Categories
      module CreateCategory
        class CreateCategoryResultValidationFailed < Base
          implements Interfaces::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
