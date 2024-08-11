module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingRequiredKeyword
          class CreateUsedSofmapCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                           CreateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                CreateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed
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
