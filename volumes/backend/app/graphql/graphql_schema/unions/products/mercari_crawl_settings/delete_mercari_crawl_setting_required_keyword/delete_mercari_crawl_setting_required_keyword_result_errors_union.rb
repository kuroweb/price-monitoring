module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingRequiredKeyword
          class DeleteMercariCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                           DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed
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
