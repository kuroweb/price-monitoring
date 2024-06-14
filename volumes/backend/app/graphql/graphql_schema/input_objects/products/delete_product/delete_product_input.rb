module GraphqlSchema
  module InputObjects
    module Products
      module DeleteProduct
        class DeleteProductInput < Base
          argument :id, ID, required: true
        end
      end
    end
  end
end
