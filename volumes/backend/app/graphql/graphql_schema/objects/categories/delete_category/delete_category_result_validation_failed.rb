module GraphqlSchema
  module Objects
    module Categories
      module DeleteCategory
        class DeleteCategoryResultValidationFailed < Base
          implements Interfaces::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
