module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeProduct
          class CreateMercariCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                           CreateMercariCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                           CreateMercariCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeProductResultSuccess"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                CreateMercariCrawlSettingExcludeProductResultSuccess
              when "CreateMercariCrawlSettingExcludeProductResultError"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                CreateMercariCrawlSettingExcludeProductResultError
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
