module GraphqlSchema
  module InputObjects
    module Products
      class DeleteProductInput < Base
        argument :id, ID, required: true
      end
    end
  end
end
