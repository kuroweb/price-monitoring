module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeProduct
          class CreateMercariCrawlSettingExcludeProductResultSuccess < Base
            implements Interfaces::ResultBase

            field :mercari_crawl_setting_exclude_product,
                  Objects::Products::MercariCrawlSettings::MercariCrawlSettingExcludeProduct,
                  null: false
          end
        end
      end
    end
  end
end
