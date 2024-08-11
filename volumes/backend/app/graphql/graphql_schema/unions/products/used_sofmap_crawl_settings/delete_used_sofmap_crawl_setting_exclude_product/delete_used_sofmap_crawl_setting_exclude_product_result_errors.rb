module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeProduct
          class DeleteUsedSofmapCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                           DeleteUsedSofmapCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                DeleteUsedSofmapCrawlSettingExcludeProductResultValidationFailedType
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
