module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeProduct
          class UpdateIosysCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                           UpdateIosysCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                           UpdateIosysCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeProductResultSuccess"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                UpdateIosysCrawlSettingExcludeProductResultSuccess
              when "UpdateIosysCrawlSettingExcludeProductResultError"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                UpdateIosysCrawlSettingExcludeProductResultError
              else
                raise "Unexpected UpdateIosysCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
