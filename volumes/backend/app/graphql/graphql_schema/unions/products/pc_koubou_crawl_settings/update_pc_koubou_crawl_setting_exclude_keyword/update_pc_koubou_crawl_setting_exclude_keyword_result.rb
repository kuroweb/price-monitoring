module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeKeyword
          class UpdatePcKoubouCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                           UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                           UpdatePcKoubouCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccess
              when "UpdatePcKoubouCrawlSettingExcludeKeywordResultError"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                UpdatePcKoubouCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected UpdatePcKoubouCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
