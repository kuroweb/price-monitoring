module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingRequiredKeyword
          class CreatePcKoubouCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                           CreatePcKoubouCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                CreatePcKoubouCrawlSettingRequiredKeywordResultValidationFailed
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
