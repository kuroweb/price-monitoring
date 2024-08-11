module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                           CreatePcKoubouCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                           CreatePcKoubouCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                CreatePcKoubouCrawlSettingExcludeKeywordResultSuccessType
              when "CreatePcKoubouCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                CreatePcKoubouCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected CreatePcKoubouCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
