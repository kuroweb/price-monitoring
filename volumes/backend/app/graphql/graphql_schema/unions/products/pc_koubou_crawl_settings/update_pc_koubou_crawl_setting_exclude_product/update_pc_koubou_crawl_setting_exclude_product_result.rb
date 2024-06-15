module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module UpdatePcKoubouCrawlSettingExcludeProduct
          class UpdatePcKoubouCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProduct::
                           UpdatePcKoubouCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProduct::
                           UpdatePcKoubouCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdatePcKoubouCrawlSettingExcludeProductResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProduct::
                UpdatePcKoubouCrawlSettingExcludeProductResultSuccess
              when "UpdatePcKoubouCrawlSettingExcludeProductResultError"
                Objects::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProduct::
                UpdatePcKoubouCrawlSettingExcludeProductResultError
              else
                raise "Unexpected UpdatePcKoubouCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
