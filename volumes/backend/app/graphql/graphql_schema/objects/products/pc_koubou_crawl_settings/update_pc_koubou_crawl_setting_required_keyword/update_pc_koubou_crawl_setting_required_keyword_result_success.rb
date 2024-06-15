module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingRequiredKeyword
          class UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :pc_koubou_crawl_setting_required_keyword,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
