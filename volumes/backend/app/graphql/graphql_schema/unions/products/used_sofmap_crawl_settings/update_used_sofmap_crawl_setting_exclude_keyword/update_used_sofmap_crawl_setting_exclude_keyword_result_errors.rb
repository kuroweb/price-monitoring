module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeKeyword
          class UpdateUsedSofmapCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                           UpdateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                UpdateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType
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
