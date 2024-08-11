module GraphqlSchema
  module Unions
    module Products
      module PcKoubouCrawlSettings
        module CreatePcKoubouCrawlSettingRequiredKeyword
          class CreatePcKoubouCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                           CreatePcKoubouCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                           CreatePcKoubouCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreatePcKoubouCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                CreatePcKoubouCrawlSettingRequiredKeywordResultSuccessType
              when "CreatePcKoubouCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword::
                CreatePcKoubouCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected CreatePcKoubouCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
