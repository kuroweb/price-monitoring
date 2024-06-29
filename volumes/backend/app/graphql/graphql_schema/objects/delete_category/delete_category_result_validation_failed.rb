module GraphqlSchema
  module Objects
    module DeleteCategory
      class DeleteCategoryResultValidationFailed < Base
        implements Interfaces::UserError

        field :details, [ErrorDetail], null: false
      end
    end
  end
end
