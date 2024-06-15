module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResultValidationFailed < Base
            implements Interfaces::Products::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
