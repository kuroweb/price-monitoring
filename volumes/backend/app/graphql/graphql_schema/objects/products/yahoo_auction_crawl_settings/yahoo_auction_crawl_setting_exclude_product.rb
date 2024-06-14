module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingExcludeProduct < Base
          implements GraphQL::Types::Relay::Node

          field :id, ID, null: false
          field :yahoo_auction_crawl_setting_id, Int, null: false
          field :external_id, String, null: false
          field :created_at, GraphQL::Types::ISO8601DateTime, null: false
          field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        end
      end
    end
  end
end
