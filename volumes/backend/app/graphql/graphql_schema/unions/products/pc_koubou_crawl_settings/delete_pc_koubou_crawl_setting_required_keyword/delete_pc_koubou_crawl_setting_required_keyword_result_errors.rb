module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingRequiredKeyword
          class DeletePcKoubouCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                           DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed
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
