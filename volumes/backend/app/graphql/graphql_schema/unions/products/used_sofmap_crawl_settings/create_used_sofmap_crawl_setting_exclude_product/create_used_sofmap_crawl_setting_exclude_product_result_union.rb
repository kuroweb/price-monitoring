module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeProduct
          class CreateUsedSofmapCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                           CreateUsedSofmapCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                           CreateUsedSofmapCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                CreateUsedSofmapCrawlSettingExcludeProductResultSuccessType
              when "CreateUsedSofmapCrawlSettingExcludeProductResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                CreateUsedSofmapCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected CreateUsedSofmapCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
