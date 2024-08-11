module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeProduct
          class DeleteMercariCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                           DeleteMercariCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                DeleteMercariCrawlSettingExcludeProductResultValidationFailed
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
