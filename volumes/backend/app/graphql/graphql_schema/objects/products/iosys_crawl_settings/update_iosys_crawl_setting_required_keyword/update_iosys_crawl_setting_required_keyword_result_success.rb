module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :iosys_crawl_setting_required_keyword,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
