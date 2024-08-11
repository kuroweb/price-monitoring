module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingRequiredKeyword
          class CreateMercariCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                           CreateMercariCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                CreateMercariCrawlSettingRequiredKeywordResultValidationFailedType
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
