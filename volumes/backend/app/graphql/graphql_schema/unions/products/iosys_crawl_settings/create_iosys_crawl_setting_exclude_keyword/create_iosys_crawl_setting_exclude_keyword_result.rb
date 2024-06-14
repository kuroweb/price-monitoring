module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeKeyword
          class CreateIosysCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                           CreateIosysCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                           CreateIosysCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                CreateIosysCrawlSettingExcludeKeywordResultSuccess
              when "CreateIosysCrawlSettingExcludeKeywordResultError"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                CreateIosysCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected CreateIosysCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
