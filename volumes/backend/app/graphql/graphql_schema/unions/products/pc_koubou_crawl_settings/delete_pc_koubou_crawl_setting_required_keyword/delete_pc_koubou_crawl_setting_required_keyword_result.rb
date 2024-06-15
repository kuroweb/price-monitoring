module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingRequiredKeyword
          class DeletePcKoubouCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                           DeletePcKoubouCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                           DeletePcKoubouCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                DeletePcKoubouCrawlSettingRequiredKeywordResultSuccess
              when "DeletePcKoubouCrawlSettingRequiredKeywordResultError"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                DeletePcKoubouCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected DeletePcKoubouCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
