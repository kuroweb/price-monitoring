module GraphqlSchema
  module Unions
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingRequiredKeyword
          class UpdateMercariCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                           UpdateMercariCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                           UpdateMercariCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateMercariCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                UpdateMercariCrawlSettingRequiredKeywordResultSuccessType
              when "UpdateMercariCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                UpdateMercariCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected UpdateMercariCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
