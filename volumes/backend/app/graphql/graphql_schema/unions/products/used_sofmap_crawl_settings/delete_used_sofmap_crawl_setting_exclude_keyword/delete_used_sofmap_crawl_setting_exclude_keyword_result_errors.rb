module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeKeyword
          class DeleteUsedSofmapCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                           DeleteUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                DeleteUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType
              else
                raise "Unexpected error type: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
