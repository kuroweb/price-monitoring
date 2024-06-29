module GraphqlSchema
  module InputObjects
    class DeleteCategoryInput < Base
      argument :id, ID, required: true
    end
  end
end
