module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeProduct
          class UpdateUsedSofmapCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct::
                           UpdateUsedSofmapCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct::
                UpdateUsedSofmapCrawlSettingExcludeProductResultValidationFailedType
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
