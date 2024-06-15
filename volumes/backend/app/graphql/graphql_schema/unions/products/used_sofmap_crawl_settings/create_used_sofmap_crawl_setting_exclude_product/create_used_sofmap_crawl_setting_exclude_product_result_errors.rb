module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeProduct
          class CreateUsedSofmapCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                           CreateUsedSofmapCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                CreateUsedSofmapCrawlSettingExcludeProductResultValidationFailed
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
