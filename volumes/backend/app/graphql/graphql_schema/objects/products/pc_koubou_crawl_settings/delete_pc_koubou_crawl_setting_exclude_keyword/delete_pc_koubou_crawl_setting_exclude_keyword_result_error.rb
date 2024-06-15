module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                  DeletePcKoubouCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
