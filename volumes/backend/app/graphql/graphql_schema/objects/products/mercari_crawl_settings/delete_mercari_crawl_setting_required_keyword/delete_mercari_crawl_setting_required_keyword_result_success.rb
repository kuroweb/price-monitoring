module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingRequiredKeyword
          class DeleteMercariCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :mercari_crawl_setting_required_keyword,
                  Objects::Products::MercariCrawlSettings::MercariCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
