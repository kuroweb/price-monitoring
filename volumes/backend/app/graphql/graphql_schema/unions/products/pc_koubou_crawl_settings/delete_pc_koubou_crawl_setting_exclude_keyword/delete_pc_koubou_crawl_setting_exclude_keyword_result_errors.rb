module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                           DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed
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
