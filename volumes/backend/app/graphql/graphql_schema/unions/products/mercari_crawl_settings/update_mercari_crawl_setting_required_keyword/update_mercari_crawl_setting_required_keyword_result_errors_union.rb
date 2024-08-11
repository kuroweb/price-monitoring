module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingRequiredKeyword
          class UpdateMercariCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                           UpdateMercariCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                UpdateMercariCrawlSettingRequiredKeywordResultValidationFailedType
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
