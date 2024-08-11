module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeProduct
          class DeleteIosysCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                           DeleteIosysCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                DeleteIosysCrawlSettingExcludeProductResultValidationFailedType
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
