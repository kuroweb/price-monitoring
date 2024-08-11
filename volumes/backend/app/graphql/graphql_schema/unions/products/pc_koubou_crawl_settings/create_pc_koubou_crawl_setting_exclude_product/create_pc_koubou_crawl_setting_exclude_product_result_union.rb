module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeProduct
          class CreatePcKoubouCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                           CreatePcKoubouCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                           CreatePcKoubouCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                CreatePcKoubouCrawlSettingExcludeProductResultSuccessType
              when "CreatePcKoubouCrawlSettingExcludeProductResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct::
                CreatePcKoubouCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected CreatePcKoubouCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
