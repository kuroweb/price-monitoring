module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeProduct
          class UpdatePcKoubouCrawlSettingExcludeProductResultSuccessType < Base
            implements Interfaces::ResultBase

            field :pc_koubou_crawl_setting_exclude_product,
                  Objects::Products::PcKoubouCrawlSettings::PcKoubouCrawlSettingExcludeProductType, null: false
          end
        end
      end
    end
  end
end