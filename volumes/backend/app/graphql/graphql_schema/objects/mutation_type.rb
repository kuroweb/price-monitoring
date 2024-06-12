module GraphqlSchema
  module Objects
    class MutationType < Base
      field :create_product, mutation: Mutations::Products::CreateProduct
      field :update_product, mutation: Mutations::Products::UpdateProduct
      field :delete_product, mutation: Mutations::Products::DeleteProduct
    end
  end
end
