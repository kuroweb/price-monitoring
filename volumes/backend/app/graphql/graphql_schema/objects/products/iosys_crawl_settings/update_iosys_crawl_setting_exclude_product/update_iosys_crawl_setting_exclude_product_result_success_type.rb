module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeProduct
          class UpdateIosysCrawlSettingExcludeProductResultSuccessType < Base
            implements Interfaces::ResultBase

            field :iosys_crawl_setting_exclude_product,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingExcludeProductType, null: false
          end
        end
      end
    end
  end
end
