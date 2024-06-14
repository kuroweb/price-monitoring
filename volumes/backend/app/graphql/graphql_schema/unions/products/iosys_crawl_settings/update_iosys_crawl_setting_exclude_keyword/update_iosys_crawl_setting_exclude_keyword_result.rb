module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                           UpdateIosysCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                           UpdateIosysCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                UpdateIosysCrawlSettingExcludeKeywordResultSuccess
              when "UpdateIosysCrawlSettingExcludeKeywordResultError"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                UpdateIosysCrawlSettingExcludeKeywordResultError
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
