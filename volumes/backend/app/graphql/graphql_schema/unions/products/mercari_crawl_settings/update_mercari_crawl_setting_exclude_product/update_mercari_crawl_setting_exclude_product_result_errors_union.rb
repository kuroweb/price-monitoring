module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeProduct
          class UpdateMercariCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                           UpdateMercariCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                UpdateMercariCrawlSettingExcludeProductResultValidationFailedType
              else
                raise "Unexpected error type: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
