module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeProduct
          class UpdatePcKoubouCrawlSettingExcludeProductResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProduct::
                  UpdatePcKoubouCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
