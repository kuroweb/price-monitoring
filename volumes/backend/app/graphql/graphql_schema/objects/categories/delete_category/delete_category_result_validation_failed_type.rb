module GraphqlSchema
  module Objects
    module Categories
      module DeleteCategory
        class DeleteCategoryResultValidationFailedType < Base
          implements Interfaces::UserError

          field :details, [ErrorDetailType], null: false
        end
      end
    end
  end
end
