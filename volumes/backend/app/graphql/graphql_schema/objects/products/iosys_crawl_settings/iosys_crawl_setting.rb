module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        class IosysCrawlSetting < Base
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
          field :iosys_crawl_setting_required_keywords, [IosysCrawlSettingRequiredKeyword], null: false
          field :iosys_crawl_setting_exclude_keywords, [IosysCrawlSettingExcludeKeyword], null: false
          field :iosys_crawl_setting_exclude_products, [IosysCrawlSettingExcludeProduct], null: false

          def iosys_crawl_setting_required_keywords
            object.iosys_crawl_setting_required_keywords
          end

          def iosys_crawl_setting_exclude_keywords
            object.iosys_crawl_setting_exclude_keywords
          end

          def iosys_crawl_setting_exclude_products
            object.iosys_crawl_setting_exclude_products
          end
        end
      end
    end
  end
end
