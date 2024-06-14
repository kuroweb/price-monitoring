module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                           CreateIosysCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                           CreateIosysCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                CreateIosysCrawlSettingRequiredKeywordResultSuccess
              when "CreateIosysCrawlSettingRequiredKeywordResultError"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                CreateIosysCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected CreateIosysCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
