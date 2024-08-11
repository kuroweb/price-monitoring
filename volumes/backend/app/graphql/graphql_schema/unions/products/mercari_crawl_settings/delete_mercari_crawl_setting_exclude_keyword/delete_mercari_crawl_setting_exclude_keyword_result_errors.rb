module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeKeyword
          class DeleteMercariCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                           DeleteMercariCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                DeleteMercariCrawlSettingExcludeKeywordResultValidationFailedType
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
