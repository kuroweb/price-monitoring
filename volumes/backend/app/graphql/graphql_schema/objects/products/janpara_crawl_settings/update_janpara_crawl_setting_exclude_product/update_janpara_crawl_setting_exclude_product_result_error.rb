module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeProduct
          class UpdateJanparaCrawlSettingExcludeProductResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                  UpdateJanparaCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
