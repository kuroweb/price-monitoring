module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeKeyword
          class CreateMercariCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                           CreateMercariCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                CreateMercariCrawlSettingExcludeKeywordResultValidationFailed
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
