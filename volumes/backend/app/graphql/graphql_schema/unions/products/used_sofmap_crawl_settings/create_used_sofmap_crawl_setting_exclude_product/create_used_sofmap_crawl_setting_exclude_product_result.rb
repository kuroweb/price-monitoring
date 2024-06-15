module GraphqlSchema
  module Unions
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeProduct
          class CreateUsedSofmapCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                           CreateUsedSofmapCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                           CreateUsedSofmapCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateUsedSofmapCrawlSettingExcludeProductResultSuccess"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                CreateUsedSofmapCrawlSettingExcludeProductResultSuccess
              when "CreateUsedSofmapCrawlSettingExcludeProductResultError"
                Objects::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                CreateUsedSofmapCrawlSettingExcludeProductResultError
              else
                raise "Unexpected CreateUsedSofmapCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
