module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                           CreateIosysCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                           CreateIosysCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                CreateIosysCrawlSettingRequiredKeywordResultSuccessType
              when "CreateIosysCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                CreateIosysCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected CreateIosysCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
