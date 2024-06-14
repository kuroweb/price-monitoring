module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeKeyword
          class DeleteMercariCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                           DeleteMercariCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                           DeleteMercariCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                DeleteMercariCrawlSettingExcludeKeywordResultSuccess
              when "DeleteMercariCrawlSettingExcludeKeywordResultError"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                DeleteMercariCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected DeleteMercariCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
