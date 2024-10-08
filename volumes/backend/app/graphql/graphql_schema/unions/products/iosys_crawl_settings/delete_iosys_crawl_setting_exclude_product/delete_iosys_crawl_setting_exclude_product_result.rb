module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeProduct
          class DeleteIosysCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                           DeleteIosysCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                           DeleteIosysCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                DeleteIosysCrawlSettingExcludeProductResultSuccessType
              when "DeleteIosysCrawlSettingExcludeProductResultErrorType"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                DeleteIosysCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected DeleteIosysCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
