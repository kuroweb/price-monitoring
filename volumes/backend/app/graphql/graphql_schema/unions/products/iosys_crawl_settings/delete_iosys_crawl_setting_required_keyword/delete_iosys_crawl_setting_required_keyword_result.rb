module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingRequiredKeyword
          class DeleteIosysCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                           DeleteIosysCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                           DeleteIosysCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                DeleteIosysCrawlSettingRequiredKeywordResultSuccess
              when "DeleteIosysCrawlSettingRequiredKeywordResultError"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                DeleteIosysCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected DeleteIosysCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
