module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                           DeletePcKoubouCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                           DeletePcKoubouCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                DeletePcKoubouCrawlSettingExcludeKeywordResultSuccessType
              when "DeletePcKoubouCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                DeletePcKoubouCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected DeletePcKoubouCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
