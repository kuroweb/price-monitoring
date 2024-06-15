module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :pc_koubou_crawl_setting_exclude_keyword,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingExcludeKeyword,
                  null: false
          end
        end
      end
    end
  end
end
