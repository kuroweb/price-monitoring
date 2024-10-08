module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingRequiredKeyword
          class DeletePcKoubouCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                  DeletePcKoubouCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
