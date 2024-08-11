module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeProduct
          class DeleteMercariCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                           DeleteMercariCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                DeleteMercariCrawlSettingExcludeProductResultValidationFailedType
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
