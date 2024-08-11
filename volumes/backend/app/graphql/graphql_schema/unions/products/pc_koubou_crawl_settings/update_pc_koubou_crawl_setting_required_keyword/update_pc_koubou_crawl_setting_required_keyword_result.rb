module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingRequiredKeyword
          class UpdatePcKoubouCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                           UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                           UpdatePcKoubouCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccessType
              when "UpdatePcKoubouCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                UpdatePcKoubouCrawlSettingRequiredKeywordResultErrorType
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
