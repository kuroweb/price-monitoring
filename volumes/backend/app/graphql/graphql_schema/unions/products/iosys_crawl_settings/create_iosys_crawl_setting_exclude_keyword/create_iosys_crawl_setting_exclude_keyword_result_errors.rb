module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeKeyword
          class CreateIosysCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                           CreateIosysCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                CreateIosysCrawlSettingExcludeKeywordResultValidationFailedType
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
