module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeProduct
          class DeleteIosysCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                           DeleteIosysCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                           DeleteIosysCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteIosysCrawlSettingExcludeProductResultSuccess"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                DeleteIosysCrawlSettingExcludeProductResultSuccess
              when "DeleteIosysCrawlSettingExcludeProductResultError"
                Objects::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                DeleteIosysCrawlSettingExcludeProductResultError
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
