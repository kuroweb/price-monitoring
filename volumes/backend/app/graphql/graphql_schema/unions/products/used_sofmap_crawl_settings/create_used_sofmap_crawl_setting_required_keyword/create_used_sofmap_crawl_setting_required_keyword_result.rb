module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingRequiredKeyword
          class CreateUsedSofmapCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                           CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                           CreateUsedSofmapCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccess
              when "CreateUsedSofmapCrawlSettingRequiredKeywordResultError"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                CreateUsedSofmapCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected CreateUsedSofmapCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
