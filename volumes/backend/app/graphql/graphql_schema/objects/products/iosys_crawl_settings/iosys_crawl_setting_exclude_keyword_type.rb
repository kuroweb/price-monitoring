module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        class IosysCrawlSettingExcludeKeywordType < Base
          implements GraphQL::Types::Relay::Node

          field :id, ID, null: false
          field :iosys_crawl_setting_id, Int, null: false
          field :keyword, String, null: true
          field :created_at, GraphQL::Types::ISO8601DateTime, null: false
          field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        end
      end
    end
  end
end
