module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed < Base
            implements Interfaces::Products::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
