module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeKeyword
          class CreateUsedSofmapCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                           CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                           CreateUsedSofmapCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccess
              when "CreateUsedSofmapCrawlSettingExcludeKeywordResultError"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                CreateUsedSofmapCrawlSettingExcludeKeywordResultError
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
