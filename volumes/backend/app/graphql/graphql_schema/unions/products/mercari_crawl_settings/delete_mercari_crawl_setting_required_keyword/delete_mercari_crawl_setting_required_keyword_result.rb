module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingRequiredKeyword
          class DeleteMercariCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                           DeleteMercariCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                           DeleteMercariCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                DeleteMercariCrawlSettingRequiredKeywordResultSuccess
              when "DeleteMercariCrawlSettingRequiredKeywordResultError"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                DeleteMercariCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected DeleteMercariCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
