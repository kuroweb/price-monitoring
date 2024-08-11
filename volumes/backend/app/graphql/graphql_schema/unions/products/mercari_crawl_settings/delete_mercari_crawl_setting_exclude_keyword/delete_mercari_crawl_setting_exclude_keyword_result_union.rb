module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeKeyword
          class DeleteMercariCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                           DeleteMercariCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                           DeleteMercariCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteMercariCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                DeleteMercariCrawlSettingExcludeKeywordResultSuccessType
              when "DeleteMercariCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                DeleteMercariCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected DeleteMercariCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
