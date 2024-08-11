module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeKeyword
          class DeleteIosysCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                           DeleteIosysCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                DeleteIosysCrawlSettingExcludeKeywordResultValidationFailedType
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
