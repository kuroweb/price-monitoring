module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResultSuccess < Base
            implements Interfaces::ResultBase

            field :iosys_crawl_setting_exclude_product,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingExcludeProduct,
                  null: false
          end
        end
      end
    end
  end
end
