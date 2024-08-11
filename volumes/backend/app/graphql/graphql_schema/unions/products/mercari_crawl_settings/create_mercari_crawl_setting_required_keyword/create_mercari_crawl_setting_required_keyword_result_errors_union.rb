module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingRequiredKeyword
          class CreateMercariCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                           CreateMercariCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                CreateMercariCrawlSettingRequiredKeywordResultValidationFailed
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
