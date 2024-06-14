module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeProduct
          class DeleteMercariCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                           DeleteMercariCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                           DeleteMercariCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeProductResultSuccess"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                DeleteMercariCrawlSettingExcludeProductResultSuccess
              when "DeleteMercariCrawlSettingExcludeProductResultError"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                DeleteMercariCrawlSettingExcludeProductResultError
              else
                raise "Unexpected DeleteMercariCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
