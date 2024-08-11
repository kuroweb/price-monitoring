module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeProduct
          class UpdateMercariCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                           UpdateMercariCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                           UpdateMercariCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                UpdateMercariCrawlSettingExcludeProductResultSuccessType
              when "UpdateMercariCrawlSettingExcludeProductResultErrorType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                UpdateMercariCrawlSettingExcludeProductResultErrorType
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
