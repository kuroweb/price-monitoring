module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                           UpdateIosysCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                UpdateIosysCrawlSettingExcludeKeywordResultValidationFailed
              else
                raise "Unexpected error type: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
