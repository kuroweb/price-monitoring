module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeProduct
          class UpdateIosysCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                           UpdateIosysCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                           UpdateIosysCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                UpdateIosysCrawlSettingExcludeProductResultSuccessType
              when "UpdateIosysCrawlSettingExcludeProductResultErrorType"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                UpdateIosysCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected UpdateIosysCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
