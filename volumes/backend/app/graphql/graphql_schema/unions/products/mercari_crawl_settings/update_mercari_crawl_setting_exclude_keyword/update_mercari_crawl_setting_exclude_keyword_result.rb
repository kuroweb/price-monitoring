module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeKeyword
          class UpdateMercariCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                           UpdateMercariCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                           UpdateMercariCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                UpdateMercariCrawlSettingExcludeKeywordResultSuccess
              when "UpdateMercariCrawlSettingExcludeKeywordResultError"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                UpdateMercariCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected UpdateMercariCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
