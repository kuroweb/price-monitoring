module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeProduct
          class UpdateMercariCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                           UpdateMercariCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                           UpdateMercariCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeProductResultSuccess"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                UpdateMercariCrawlSettingExcludeProductResultSuccess
              when "UpdateMercariCrawlSettingExcludeProductResultError"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                UpdateMercariCrawlSettingExcludeProductResultError
              else
                raise "Unexpected UpdateMercariCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
