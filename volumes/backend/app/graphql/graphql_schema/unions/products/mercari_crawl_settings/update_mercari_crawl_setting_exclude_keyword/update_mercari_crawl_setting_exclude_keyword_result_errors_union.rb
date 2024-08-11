module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeKeyword
          class UpdateMercariCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                           UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed
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
