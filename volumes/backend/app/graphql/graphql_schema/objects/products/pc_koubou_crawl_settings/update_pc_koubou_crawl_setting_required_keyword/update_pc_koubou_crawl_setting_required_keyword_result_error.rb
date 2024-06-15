module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingRequiredKeyword
          class UpdatePcKoubouCrawlSettingRequiredKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                  UpdatePcKoubouCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
