module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingRequiredKeyword
          class UpdatePcKoubouCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                           UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                           UpdatePcKoubouCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccess
              when "UpdatePcKoubouCrawlSettingRequiredKeywordResultError"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                UpdatePcKoubouCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected UpdatePcKoubouCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
