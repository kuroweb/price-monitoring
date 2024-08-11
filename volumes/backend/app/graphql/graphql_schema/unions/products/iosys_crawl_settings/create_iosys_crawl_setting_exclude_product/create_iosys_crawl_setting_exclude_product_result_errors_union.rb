module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                           CreateIosysCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                CreateIosysCrawlSettingExcludeProductResultValidationFailed
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
