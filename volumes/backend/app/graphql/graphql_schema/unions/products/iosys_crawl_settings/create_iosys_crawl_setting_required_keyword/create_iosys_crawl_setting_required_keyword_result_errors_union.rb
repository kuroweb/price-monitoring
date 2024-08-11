module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                           CreateIosysCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                CreateIosysCrawlSettingRequiredKeywordResultValidationFailedType
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
