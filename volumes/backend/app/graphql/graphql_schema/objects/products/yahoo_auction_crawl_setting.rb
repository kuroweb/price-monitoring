module GraphqlSchema
  module Objects
    module Products
      class YahooAuctionCrawlSetting < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :product_id, Int, null: false
        field :keyword, String, null: false
        field :min_price, Int, null: false
        field :max_price, Int, null: false
        field :category_id, Int, null: true
        field :enabled, Boolean, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        field :yahoo_auction_crawl_setting_required_keywords, [YahooAuctionCrawlSettingRequiredKeyword], null: false
        field :yahoo_auction_crawl_setting_exclude_keywords, [YahooAuctionCrawlSettingExcludeKeyword], null: false
        field :yahoo_auction_crawl_setting_exclude_products, [YahooAuctionCrawlSettingExcludeProduct], null: false

        def yahoo_auction_crawl_setting_required_keywords
          object.yahoo_auction_crawl_setting_required_keywords
        end

        def yahoo_auction_crawl_setting_exclude_keywords
          object.yahoo_auction_crawl_setting_exclude_keywords
        end

        def yahoo_auction_crawl_setting_exclude_products
          object.yahoo_auction_crawl_setting_exclude_products
        end
      end
    end
  end
end
