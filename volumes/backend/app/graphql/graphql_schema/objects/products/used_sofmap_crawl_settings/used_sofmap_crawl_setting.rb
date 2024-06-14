module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        class UsedSofmapCrawlSetting < Base
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
          field :used_sofmap_crawl_setting_required_keywords, [UsedSofmapCrawlSettingRequiredKeyword], null: false
          field :used_sofmap_crawl_setting_exclude_keywords, [UsedSofmapCrawlSettingExcludeKeyword], null: false
          field :used_sofmap_crawl_setting_exclude_products, [UsedSofmapCrawlSettingExcludeProduct], null: false

          def used_sofmap_crawl_setting_required_keywords
            object.used_sofmap_crawl_setting_required_keywords
          end

          def used_sofmap_crawl_setting_exclude_keywords
            object.used_sofmap_crawl_setting_exclude_keywords
          end

          def used_sofmap_crawl_setting_exclude_products
            object.used_sofmap_crawl_setting_exclude_products
          end
        end
      end
    end
  end
end
