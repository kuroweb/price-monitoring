module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeKeyword
          class DeleteUsedSofmapCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                           DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                           DeleteUsedSofmapCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccess
              when "DeleteUsedSofmapCrawlSettingExcludeKeywordResultError"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                DeleteUsedSofmapCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected DeleteUsedSofmapCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
