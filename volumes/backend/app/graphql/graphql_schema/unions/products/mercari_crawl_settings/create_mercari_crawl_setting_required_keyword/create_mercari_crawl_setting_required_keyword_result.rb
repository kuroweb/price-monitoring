module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingRequiredKeyword
          class CreateMercariCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                           CreateMercariCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                           CreateMercariCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                CreateMercariCrawlSettingRequiredKeywordResultSuccessType
              when "CreateMercariCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                CreateMercariCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected CreateMercariCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
