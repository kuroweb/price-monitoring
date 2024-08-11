module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingRequiredKeyword
          class UpdateMercariCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                           UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed
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
