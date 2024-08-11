module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeProduct
          class UpdateUsedSofmapCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct::
                           UpdateUsedSofmapCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct::
                           UpdateUsedSofmapCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct::
                UpdateUsedSofmapCrawlSettingExcludeProductResultSuccessType
              when "UpdateUsedSofmapCrawlSettingExcludeProductResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct::
                UpdateUsedSofmapCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected UpdateUsedSofmapCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
