module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingRequiredKeyword
          class CreatePcKoubouCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                           CreatePcKoubouCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                           CreatePcKoubouCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                CreatePcKoubouCrawlSettingRequiredKeywordResultSuccess
              when "CreatePcKoubouCrawlSettingRequiredKeywordResultError"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                CreatePcKoubouCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected CreatePcKoubouCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
