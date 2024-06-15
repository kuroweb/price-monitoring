module GraphqlSchema
  module Objects
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeProduct
          class UpdatePcKoubouCrawlSettingExcludeProductResultValidationFailed < Base
            implements Interfaces::Products::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
