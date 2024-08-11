module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingRequiredKeyword
          class DeleteMercariCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                           DeleteMercariCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                           DeleteMercariCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                DeleteMercariCrawlSettingRequiredKeywordResultSuccessType
              when "DeleteMercariCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword::
                DeleteMercariCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected DeleteMercariCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
