module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeKeyword
          class CreateUsedSofmapCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                           CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                           CreateUsedSofmapCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType
              when "CreateUsedSofmapCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                CreateUsedSofmapCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected CreateUsedSofmapCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
