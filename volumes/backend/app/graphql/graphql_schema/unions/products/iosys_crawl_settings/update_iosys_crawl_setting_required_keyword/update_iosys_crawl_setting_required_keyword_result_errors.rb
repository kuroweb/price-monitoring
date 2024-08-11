module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                           UpdateIosysCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                UpdateIosysCrawlSettingRequiredKeywordResultValidationFailedType
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
