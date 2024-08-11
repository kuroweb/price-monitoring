module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeKeyword
          class CreateIosysCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                           CreateIosysCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                           CreateIosysCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                CreateIosysCrawlSettingExcludeKeywordResultSuccessType
              when "CreateIosysCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                CreateIosysCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected CreateIosysCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
