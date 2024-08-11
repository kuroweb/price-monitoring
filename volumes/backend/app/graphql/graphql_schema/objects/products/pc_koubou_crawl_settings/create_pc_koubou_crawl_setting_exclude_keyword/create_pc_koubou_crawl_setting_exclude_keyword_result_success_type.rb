module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :pc_koubou_crawl_setting_exclude_keyword,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingExcludeKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
