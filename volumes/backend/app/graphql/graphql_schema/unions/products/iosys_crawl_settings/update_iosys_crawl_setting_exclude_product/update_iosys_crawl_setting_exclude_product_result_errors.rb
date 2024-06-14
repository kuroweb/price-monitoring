module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeProduct
          class UpdateIosysCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                           UpdateIosysCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateIosysCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct::
                UpdateIosysCrawlSettingExcludeProductResultValidationFailed
              else
                raise "Unexpected error type: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
