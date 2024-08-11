module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeProduct
          class CreatePcKoubouCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

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
