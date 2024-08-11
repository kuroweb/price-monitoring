module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingRequiredKeyword
          class UpdateUsedSofmapCrawlSettingRequiredKeywordResultUnion < Base
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
                raise "Unexpected UpdateUsedSofmapCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
