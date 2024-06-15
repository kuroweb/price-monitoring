module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeProduct
          class CreatePcKoubouCrawlSettingExcludeProductResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                  CreatePcKoubouCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
