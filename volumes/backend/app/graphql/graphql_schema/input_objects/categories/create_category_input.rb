module GraphqlSchema
  module InputObjects
    module Categories
      class CreateCategoryInput < Base
        argument :parent_id, ID, required: false
        argument :name, String, required: true
      end
    end
  end
end
