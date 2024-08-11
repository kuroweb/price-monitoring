module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingRequiredKeyword
          class CreatePcKoubouCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :pc_koubou_crawl_setting_required_keyword,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingRequiredKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
