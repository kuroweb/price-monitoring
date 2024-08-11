module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeProduct
          class CreateMercariCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                           CreateMercariCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                           CreateMercariCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                CreateMercariCrawlSettingExcludeProductResultSuccessType
              when "CreateMercariCrawlSettingExcludeProductResultErrorType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                CreateMercariCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected CreateMercariCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
