module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingRequiredKeyword
          class DeletePcKoubouCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                           DeletePcKoubouCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                           DeletePcKoubouCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                DeletePcKoubouCrawlSettingRequiredKeywordResultSuccessType
              when "DeletePcKoubouCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                DeletePcKoubouCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected DeletePcKoubouCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
