module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeKeyword
          class UpdatePcKoubouCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                           UpdatePcKoubouCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword::
                UpdatePcKoubouCrawlSettingExcludeKeywordResultValidationFailed
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
