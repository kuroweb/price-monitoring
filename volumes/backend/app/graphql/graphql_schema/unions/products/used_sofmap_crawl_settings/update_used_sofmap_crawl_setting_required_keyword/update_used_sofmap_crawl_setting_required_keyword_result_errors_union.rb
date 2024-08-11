module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingRequiredKeyword
          class UpdateUsedSofmapCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                           UpdateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                UpdateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed
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
