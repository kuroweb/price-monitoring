module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingExcludeKeyword
          class CreatePcKoubouCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                           CreatePcKoubouCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                           CreatePcKoubouCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                CreatePcKoubouCrawlSettingExcludeKeywordResultSuccess
              when "CreatePcKoubouCrawlSettingExcludeKeywordResultError"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword::
                CreatePcKoubouCrawlSettingExcludeKeywordResultError
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
