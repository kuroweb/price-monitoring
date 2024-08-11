module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeKeyword
          class UpdateUsedSofmapCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                           UpdateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                           UpdateUsedSofmapCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                UpdateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType
              when "UpdateUsedSofmapCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                UpdateUsedSofmapCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected UpdateUsedSofmapCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
