module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module DeletePcKoubouCrawlSettingExcludeKeyword
          class DeletePcKoubouCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                           DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword::
                DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailedType
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
