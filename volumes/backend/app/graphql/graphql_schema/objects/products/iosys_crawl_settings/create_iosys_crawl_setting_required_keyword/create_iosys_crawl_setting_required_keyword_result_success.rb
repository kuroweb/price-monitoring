module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :iosys_crawl_setting_required_keyword,
                  Objects::Products::IosysCrawlSettings::IosysCrawlSettingRequiredKeyword,
                  null: false
          end
        end
      end
    end
  end
end
