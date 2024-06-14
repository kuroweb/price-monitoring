module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                           UpdateIosysCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                           UpdateIosysCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                UpdateIosysCrawlSettingRequiredKeywordResultSuccess
              when "UpdateIosysCrawlSettingRequiredKeywordResultError"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                UpdateIosysCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected UpdateIosysCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
