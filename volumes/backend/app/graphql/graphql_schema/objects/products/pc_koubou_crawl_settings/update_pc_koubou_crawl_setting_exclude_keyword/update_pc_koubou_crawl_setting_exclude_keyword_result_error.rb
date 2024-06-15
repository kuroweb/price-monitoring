module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeKeyword
          class UpdatePcKoubouCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                  UpdatePcKoubouCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
