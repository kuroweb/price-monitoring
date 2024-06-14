module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingRequiredKeyword
          class CreateMercariCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                           CreateMercariCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                           CreateMercariCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                CreateMercariCrawlSettingRequiredKeywordResultSuccess
              when "CreateMercariCrawlSettingRequiredKeywordResultError"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword::
                CreateMercariCrawlSettingRequiredKeywordResultError
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
