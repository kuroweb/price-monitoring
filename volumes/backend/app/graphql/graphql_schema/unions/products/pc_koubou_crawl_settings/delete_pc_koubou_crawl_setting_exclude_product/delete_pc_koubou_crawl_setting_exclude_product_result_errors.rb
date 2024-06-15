module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeProduct
          class DeletePcKoubouCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                           DeletePcKoubouCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct::
                DeletePcKoubouCrawlSettingExcludeProductResultValidationFailed
              else
                raise "Unexpected error type: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
