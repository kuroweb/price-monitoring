module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                           DeletePcKoubouCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                           DeletePcKoubouCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                DeletePcKoubouCrawlSettingExcludeKeywordResultSuccess
              when "DeletePcKoubouCrawlSettingExcludeKeywordResultError"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                DeletePcKoubouCrawlSettingExcludeKeywordResultError
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
