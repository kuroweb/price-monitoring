module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeKeyword
          class CreateMercariCrawlSettingExcludeKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :mercari_crawl_setting_exclude_keyword,
                  Objects::Products::MercariCrawlSettings::MercariCrawlSettingExcludeKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
