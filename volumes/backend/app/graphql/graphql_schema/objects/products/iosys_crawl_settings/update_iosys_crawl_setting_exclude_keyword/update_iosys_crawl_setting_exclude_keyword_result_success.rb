module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :iosys_crawl_setting_exclude_keyword,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingExcludeKeyword, null: false
          end
        end
      end
    end
  end
end
