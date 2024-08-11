module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                           UpdateIosysCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                UpdateIosysCrawlSettingExcludeKeywordResultValidationFailedType
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
