module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        class PcKoubouCrawlSetting < Base
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
          field :pc_koubou_crawl_setting_required_keywords, [PcKoubouCrawlSettingRequiredKeyword], null: false
          field :pc_koubou_crawl_setting_exclude_keywords, [PcKoubouCrawlSettingExcludeKeyword], null: false
          field :pc_koubou_crawl_setting_exclude_products, [PcKoubouCrawlSettingExcludeProduct], null: false

          def pc_koubou_crawl_setting_required_keywords
            object.pc_koubou_crawl_setting_required_keywords
          end

          def pc_koubou_crawl_setting_exclude_keywords
            object.pc_koubou_crawl_setting_exclude_keywords
          end

          def pc_koubou_crawl_setting_exclude_products
            object.pc_koubou_crawl_setting_exclude_products
          end
        end
      end
    end
  end
end
