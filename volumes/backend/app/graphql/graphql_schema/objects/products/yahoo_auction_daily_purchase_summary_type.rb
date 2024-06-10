module GraphqlSchema
  module Objects
    module Products
      class YahooAuctionDailyPurchaseSummaryType < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :product_id, Int, null: false
        field :average_purchase_price, Int, null: true
        field :purchase_count, Int, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      end
    end
  end
end
