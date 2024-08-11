module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeKeyword
          class UpdatePcKoubouCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                           UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                           UpdatePcKoubouCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccessType
              when "UpdatePcKoubouCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                UpdatePcKoubouCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected UpdatePcKoubouCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
