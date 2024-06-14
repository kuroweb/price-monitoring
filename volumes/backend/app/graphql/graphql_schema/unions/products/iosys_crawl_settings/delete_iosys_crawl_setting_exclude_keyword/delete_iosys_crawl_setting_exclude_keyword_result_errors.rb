module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeKeyword
          class DeleteIosysCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                           DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed
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
