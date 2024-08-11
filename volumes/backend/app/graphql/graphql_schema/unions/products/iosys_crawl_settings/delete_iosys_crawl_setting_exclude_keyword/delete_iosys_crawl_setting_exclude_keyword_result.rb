module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeKeyword
          class DeleteIosysCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                           DeleteIosysCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                           DeleteIosysCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                DeleteIosysCrawlSettingExcludeKeywordResultSuccessType
              when "DeleteIosysCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                DeleteIosysCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected DeleteIosysCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
