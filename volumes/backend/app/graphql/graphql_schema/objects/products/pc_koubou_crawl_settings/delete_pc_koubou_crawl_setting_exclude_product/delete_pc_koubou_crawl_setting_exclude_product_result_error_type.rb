module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeProduct
          class DeletePcKoubouCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                  DeletePcKoubouCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
