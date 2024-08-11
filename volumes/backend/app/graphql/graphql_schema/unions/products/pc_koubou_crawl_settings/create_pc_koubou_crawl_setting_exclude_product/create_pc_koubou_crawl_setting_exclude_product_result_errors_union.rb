module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeProduct
          class CreatePcKoubouCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                           CreatePcKoubouCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                CreatePcKoubouCrawlSettingExcludeProductResultValidationFailed
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
