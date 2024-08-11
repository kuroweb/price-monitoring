module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeKeyword
          class DeleteUsedSofmapCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                           DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                           DeleteUsedSofmapCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccessType
              when "DeleteUsedSofmapCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                DeleteUsedSofmapCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected DeleteUsedSofmapCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
