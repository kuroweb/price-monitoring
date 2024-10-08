module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeKeyword
          class CreateMercariCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                           CreateMercariCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                           CreateMercariCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                CreateMercariCrawlSettingExcludeKeywordResultSuccessType
              when "CreateMercariCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                CreateMercariCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected CreateMercariCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
