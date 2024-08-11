module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeKeyword
          class UpdateMercariCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                           UpdateMercariCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                           UpdateMercariCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                UpdateMercariCrawlSettingExcludeKeywordResultSuccessType
              when "UpdateMercariCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                UpdateMercariCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected UpdateMercariCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
