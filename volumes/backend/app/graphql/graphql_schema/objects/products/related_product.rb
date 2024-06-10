module GraphqlSchema
  module Objects
    module Products
      class RelatedProduct < Base
        field :platform, String, null: false
        field :product_id, Int, null: false
        field :external_id, String, null: false
        field :name, String, null: false
        field :thumbnail_url, String, null: false
        field :price, Int, null: false
        field :buyout_price, Int, null: true
        field :published, Boolean, null: false
        field :bought_date, GraphQL::Types::ISO8601DateTime, null: true
        field :end_date, GraphQL::Types::ISO8601DateTime, null: true
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      end
    end
  end
end
