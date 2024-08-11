module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeProduct
          class DeletePcKoubouCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                           DeletePcKoubouCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                           DeletePcKoubouCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                DeletePcKoubouCrawlSettingExcludeProductResultSuccessType
              when "DeletePcKoubouCrawlSettingExcludeProductResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                DeletePcKoubouCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected DeletePcKoubouCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
