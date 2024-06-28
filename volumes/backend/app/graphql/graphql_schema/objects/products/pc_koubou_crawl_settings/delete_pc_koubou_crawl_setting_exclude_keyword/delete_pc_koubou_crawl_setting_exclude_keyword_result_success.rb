module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :pc_koubou_crawl_setting_exclude_keyword,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingExcludeKeyword, null: false
          end
        end
      end
    end
  end
end
