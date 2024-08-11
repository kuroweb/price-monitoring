module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeProduct
          class CreateMercariCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                           CreateMercariCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                CreateMercariCrawlSettingExcludeProductResultValidationFailedType
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
