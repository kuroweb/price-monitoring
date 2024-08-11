module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingRequiredKeyword
          class DeleteIosysCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                           DeleteIosysCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                           DeleteIosysCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                DeleteIosysCrawlSettingRequiredKeywordResultSuccessType
              when "DeleteIosysCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                DeleteIosysCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected DeleteIosysCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
