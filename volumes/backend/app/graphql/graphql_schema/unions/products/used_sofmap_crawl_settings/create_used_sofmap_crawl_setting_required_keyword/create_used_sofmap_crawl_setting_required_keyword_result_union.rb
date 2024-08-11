module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingRequiredKeyword
          class CreateUsedSofmapCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                           CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                           CreateUsedSofmapCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType
              when "CreateUsedSofmapCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                CreateUsedSofmapCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected CreateUsedSofmapCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
