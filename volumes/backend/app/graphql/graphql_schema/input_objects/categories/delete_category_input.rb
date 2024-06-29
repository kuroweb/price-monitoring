module GraphqlSchema
  module InputObjects
    module Categories
      class DeleteCategoryInput < Base
        argument :id, ID, required: true
      end
    end
  end
end
