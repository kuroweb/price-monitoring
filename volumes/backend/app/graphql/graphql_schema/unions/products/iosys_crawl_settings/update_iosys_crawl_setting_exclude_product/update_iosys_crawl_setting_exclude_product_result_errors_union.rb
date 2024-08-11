module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeProduct
          class UpdateIosysCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                           UpdateIosysCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                UpdateIosysCrawlSettingExcludeProductResultValidationFailedType
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
