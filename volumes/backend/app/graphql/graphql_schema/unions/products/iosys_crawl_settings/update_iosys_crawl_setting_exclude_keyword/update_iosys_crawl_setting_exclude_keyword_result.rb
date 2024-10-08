module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                           UpdateIosysCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                           UpdateIosysCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                UpdateIosysCrawlSettingExcludeKeywordResultSuccessType
              when "UpdateIosysCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                UpdateIosysCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected UpdateIosysCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
