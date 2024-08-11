module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingRequiredKeyword
          class DeleteUsedSofmapCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                           DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                           DeleteUsedSofmapCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccessType
              when "DeleteUsedSofmapCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                DeleteUsedSofmapCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected DeleteUsedSofmapCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
