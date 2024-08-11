module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeProduct
          class DeleteMercariCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                           DeleteMercariCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                           DeleteMercariCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                DeleteMercariCrawlSettingExcludeProductResultSuccessType
              when "DeleteMercariCrawlSettingExcludeProductResultErrorType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                DeleteMercariCrawlSettingExcludeProductResultErrorType
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
