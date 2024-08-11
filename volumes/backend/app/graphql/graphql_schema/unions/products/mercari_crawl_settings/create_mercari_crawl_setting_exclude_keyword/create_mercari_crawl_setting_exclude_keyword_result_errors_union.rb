module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeKeyword
          class CreateMercariCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                           CreateMercariCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                CreateMercariCrawlSettingExcludeKeywordResultValidationFailedType
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
