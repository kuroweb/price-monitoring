module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingRequiredKeyword
          class DeleteIosysCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                           DeleteIosysCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                DeleteIosysCrawlSettingRequiredKeywordResultValidationFailedType
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
