module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeProduct
          class DeleteUsedSofmapCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                           DeleteUsedSofmapCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                           DeleteUsedSofmapCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                DeleteUsedSofmapCrawlSettingExcludeProductResultSuccessType
              when "DeleteUsedSofmapCrawlSettingExcludeProductResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                DeleteUsedSofmapCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected DeleteUsedSofmapCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
