module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                           CreateIosysCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                CreateIosysCrawlSettingExcludeProductResultValidationFailedType
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
