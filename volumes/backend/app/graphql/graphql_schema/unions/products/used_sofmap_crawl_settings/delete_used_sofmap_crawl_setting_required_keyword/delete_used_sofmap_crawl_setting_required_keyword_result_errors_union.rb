module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingRequiredKeyword
          class DeleteUsedSofmapCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                           DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed
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
