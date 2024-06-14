module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeKeyword
          class DeleteIosysCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                           DeleteIosysCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                           DeleteIosysCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                DeleteIosysCrawlSettingExcludeKeywordResultSuccess
              when "DeleteIosysCrawlSettingExcludeKeywordResultError"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                DeleteIosysCrawlSettingExcludeKeywordResultError
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
