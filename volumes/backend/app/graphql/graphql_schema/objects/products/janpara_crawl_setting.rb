module GraphqlSchema
  module Objects
    module Products
      class JanparaCrawlSetting < Base
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
        field :janpara_crawl_setting_required_keywords, [JanparaCrawlSettingRequiredKeyword], null: false
        field :janpara_crawl_setting_exclude_keywords, [JanparaCrawlSettingExcludeKeyword], null: false
        field :janpara_crawl_setting_exclude_products, [JanparaCrawlSettingExcludeProduct], null: false

        def janpara_crawl_setting_required_keywords
          object.janpara_crawl_setting_required_keywords
        end

        def janpara_crawl_setting_exclude_keywords
          object.janpara_crawl_setting_exclude_keywords
        end

        def janpara_crawl_setting_exclude_products
          object.janpara_crawl_setting_exclude_products
        end
      end
    end
  end
end
