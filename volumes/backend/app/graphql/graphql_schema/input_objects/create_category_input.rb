module GraphqlSchema
  module InputObjects
    class CreateCategoryInput < Base
      argument :parent_id, ID, required: false
      argument :name, String, required: true
    end
  end
end
