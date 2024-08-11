module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingRequiredKeyword
          class UpdateUsedSofmapCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                           UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                           UpdateUsedSofmapCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType
              when "UpdateUsedSofmapCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                UpdateUsedSofmapCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected UpdateUsedSofmapCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
