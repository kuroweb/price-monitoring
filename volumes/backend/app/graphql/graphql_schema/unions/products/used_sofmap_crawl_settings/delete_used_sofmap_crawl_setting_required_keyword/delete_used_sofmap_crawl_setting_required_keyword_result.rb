module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingRequiredKeyword
          class DeleteUsedSofmapCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                           DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                           DeleteUsedSofmapCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccess
              when "DeleteUsedSofmapCrawlSettingRequiredKeywordResultError"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                DeleteUsedSofmapCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected DeleteUsedSofmapCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
