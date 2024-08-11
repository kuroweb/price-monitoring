module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingRequiredKeyword
          class CreatePcKoubouCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                           CreatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                CreatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType
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
