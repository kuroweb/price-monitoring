module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeKeyword
          class UpdateMercariCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                           UpdateMercariCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                UpdateMercariCrawlSettingExcludeKeywordResultValidationFailedType
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
