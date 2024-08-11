module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingRequiredKeyword
          class UpdateMercariCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :mercari_crawl_setting_required_keyword,
                  Objects::Products::MercariCrawlSettings::MercariCrawlSettingRequiredKeywordType, null: false
          end
        end
      end
    end
  end
end
