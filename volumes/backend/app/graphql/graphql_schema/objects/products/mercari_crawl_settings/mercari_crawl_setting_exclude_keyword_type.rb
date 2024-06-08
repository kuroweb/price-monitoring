module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        class MercariCrawlSettingExcludeKeywordType < Base
          implements GraphQL::Types::Relay::Node

          field :id, ID, null: false
          field :mercari_crawl_setting_id, Int, null: false
          field :keyword, String, null: true
          field :created_at, GraphQL::Types::ISO8601DateTime, null: false
          field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        end
      end
    end
  end
end
