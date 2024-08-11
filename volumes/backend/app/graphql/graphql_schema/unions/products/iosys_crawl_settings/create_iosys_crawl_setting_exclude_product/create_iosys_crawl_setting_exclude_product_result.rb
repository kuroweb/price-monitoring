module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                           CreateIosysCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                           CreateIosysCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                CreateIosysCrawlSettingExcludeProductResultSuccessType
              when "CreateIosysCrawlSettingExcludeProductResultErrorType"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                CreateIosysCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected CreateIosysCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
