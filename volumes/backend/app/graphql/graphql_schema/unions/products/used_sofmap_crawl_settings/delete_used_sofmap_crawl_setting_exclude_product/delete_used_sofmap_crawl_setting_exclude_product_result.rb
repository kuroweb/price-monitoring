module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeProduct
          class DeleteUsedSofmapCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                           DeleteUsedSofmapCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                           DeleteUsedSofmapCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteUsedSofmapCrawlSettingExcludeProductResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                DeleteUsedSofmapCrawlSettingExcludeProductResultSuccess
              when "DeleteUsedSofmapCrawlSettingExcludeProductResultError"
                Objects::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                DeleteUsedSofmapCrawlSettingExcludeProductResultError
              else
                raise "Unexpected DeleteUsedSofmapCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
