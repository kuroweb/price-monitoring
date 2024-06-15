module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeProduct
          class CreatePcKoubouCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                           CreatePcKoubouCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                           CreatePcKoubouCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingExcludeProductResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                CreatePcKoubouCrawlSettingExcludeProductResultSuccess
              when "CreatePcKoubouCrawlSettingExcludeProductResultError"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                CreatePcKoubouCrawlSettingExcludeProductResultError
              else
                raise "Unexpected CreatePcKoubouCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
