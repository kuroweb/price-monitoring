module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingRequiredKeyword
          class DeleteIosysCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                           DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed
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
