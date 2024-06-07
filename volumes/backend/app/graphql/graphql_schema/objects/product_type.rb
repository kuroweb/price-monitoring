module GraphqlSchema
  module Objects
    class ProductType < Base
      implements GraphQL::Types::Relay::Node

      field :id, ID, null: false
      field :name, String, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :related_products, [RelatedProductType], null: false do
        argument :platform_mask, String, required: true
        argument :page, Int, required: false
        argument :per, Int, required: false
        argument :sort, String, required: false
        argument :order, String, required: false
      end

      def related_products(platform_mask:, page: nil, per: nil, sort: nil, order: nil)
        Search::RetrieveRelatedProduct.call(
          params: {
            product_id: object.id,
            platform_mask:, page:, per:, sort:, order:
          }
        ).products
      end
    end
  end
end
