module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :iosys_crawl_setting_required_keyword,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingRequiredKeywordType, null: false
          end
        end
      end
    end
  end
end
