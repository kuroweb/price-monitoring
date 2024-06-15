module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeProduct
          class DeletePcKoubouCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                           DeletePcKoubouCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                           DeletePcKoubouCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeProductResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                DeletePcKoubouCrawlSettingExcludeProductResultSuccess
              when "DeletePcKoubouCrawlSettingExcludeProductResultError"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                DeletePcKoubouCrawlSettingExcludeProductResultError
              else
                raise "Unexpected DeletePcKoubouCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
