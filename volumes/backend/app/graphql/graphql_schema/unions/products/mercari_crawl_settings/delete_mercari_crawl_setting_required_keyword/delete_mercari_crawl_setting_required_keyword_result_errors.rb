module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingRequiredKeyword
          class DeleteMercariCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                           DeleteMercariCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                DeleteMercariCrawlSettingRequiredKeywordResultValidationFailedType
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
