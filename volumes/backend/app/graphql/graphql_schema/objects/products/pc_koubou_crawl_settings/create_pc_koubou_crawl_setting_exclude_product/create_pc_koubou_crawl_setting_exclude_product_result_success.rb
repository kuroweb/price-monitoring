module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeProduct
          class CreatePcKoubouCrawlSettingExcludeProductResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :pc_koubou_crawl_setting_exclude_product,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingExcludeProduct,
                  null: false
          end
        end
      end
    end
  end
end
