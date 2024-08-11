module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeKeyword
          class CreateIosysCrawlSettingExcludeKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :iosys_crawl_setting_exclude_keyword,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingExcludeKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
