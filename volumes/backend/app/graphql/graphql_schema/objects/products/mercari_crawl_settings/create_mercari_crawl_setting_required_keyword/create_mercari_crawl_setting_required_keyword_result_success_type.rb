module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingRequiredKeyword
          class CreateMercariCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :mercari_crawl_setting_required_keyword,
                  Objects::Products::MercariCrawlSettings::MercariCrawlSettingRequiredKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
