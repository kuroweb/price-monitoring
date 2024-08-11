module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                           CreatePcKoubouCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                CreatePcKoubouCrawlSettingExcludeKeywordResultValidationFailedType
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
