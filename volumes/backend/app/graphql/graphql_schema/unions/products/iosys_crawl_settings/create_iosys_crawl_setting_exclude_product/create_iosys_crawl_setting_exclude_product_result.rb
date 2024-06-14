module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                           CreateIosysCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                           CreateIosysCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeProductResultSuccess"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                CreateIosysCrawlSettingExcludeProductResultSuccess
              when "CreateIosysCrawlSettingExcludeProductResultError"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                CreateIosysCrawlSettingExcludeProductResultError
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
