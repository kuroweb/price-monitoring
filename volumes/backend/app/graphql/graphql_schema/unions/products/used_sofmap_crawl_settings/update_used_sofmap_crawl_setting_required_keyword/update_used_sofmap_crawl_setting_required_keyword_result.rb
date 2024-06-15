module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingRequiredKeyword
          class UpdateUsedSofmapCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                           UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                           UpdateUsedSofmapCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccess
              when "UpdateUsedSofmapCrawlSettingRequiredKeywordResultError"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                UpdateUsedSofmapCrawlSettingRequiredKeywordResultError
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
