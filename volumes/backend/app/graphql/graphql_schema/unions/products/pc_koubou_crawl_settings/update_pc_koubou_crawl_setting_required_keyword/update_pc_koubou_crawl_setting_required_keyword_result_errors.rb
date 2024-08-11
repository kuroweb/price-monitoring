module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingRequiredKeyword
          class UpdatePcKoubouCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                           UpdatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
                UpdatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType
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
