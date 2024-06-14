module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeKeyword
          class CreateMercariCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                           CreateMercariCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                           CreateMercariCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateMercariCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                CreateMercariCrawlSettingExcludeKeywordResultSuccess
              when "CreateMercariCrawlSettingExcludeKeywordResultError"
                Objects::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                CreateMercariCrawlSettingExcludeKeywordResultError
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
