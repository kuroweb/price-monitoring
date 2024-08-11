module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeKeyword
          class CreateUsedSofmapCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                           CreateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                CreateUsedSofmapCrawlSettingExcludeKeywordResultValidationFailedType
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
