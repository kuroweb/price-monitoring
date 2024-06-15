module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                  CreatePcKoubouCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
