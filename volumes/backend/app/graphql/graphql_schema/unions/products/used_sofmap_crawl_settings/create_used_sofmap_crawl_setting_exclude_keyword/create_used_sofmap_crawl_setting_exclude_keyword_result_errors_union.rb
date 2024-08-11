module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeKeyword
          class CreateUsedSofmapCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                           CreateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                CreateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailed
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
