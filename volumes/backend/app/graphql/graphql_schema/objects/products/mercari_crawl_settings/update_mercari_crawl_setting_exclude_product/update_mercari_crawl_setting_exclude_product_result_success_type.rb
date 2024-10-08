module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeProduct
          class UpdateMercariCrawlSettingExcludeProductResultSuccessType < Base
            implements Interfaces::ResultBase

            field :mercari_crawl_setting_exclude_product,
                  Objects::Products::MercariCrawlSettings::MercariCrawlSettingExcludeProductType, null: false
          end
        end
      end
    end
  end
end
