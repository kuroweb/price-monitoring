module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeKeyword
          class DeleteMercariCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                           DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed
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
