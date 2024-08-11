module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                           UpdateIosysCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                           UpdateIosysCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                UpdateIosysCrawlSettingRequiredKeywordResultSuccessType
              when "UpdateIosysCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                UpdateIosysCrawlSettingRequiredKeywordResultErrorType
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
