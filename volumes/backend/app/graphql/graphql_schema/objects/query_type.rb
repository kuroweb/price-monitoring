module GraphqlSchema
  module Objects
    class QueryType < Base
      include GraphQL::Types::Relay::HasNodeField
      include GraphQL::Types::Relay::HasNodesField

      field :product, Objects::ProductType, null: false do
        description "product"
        argument :id, ID, required: true
      end

      field :products, [Objects::ProductType], null: false do
        description "products"
        argument :id, ID, required: false
        argument :name, String, required: false
      end

      def product(id:)
        ::Product.find(id)
      end

      def products(id: nil, name: nil)
        products = ::Product.all
        products = products.where(id:) if id.present?
        products = products.where("name LIKE ?", "%#{name}%") if id.present?
        products
      end
    end
  end
end
