module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeProduct
          class UpdateJanparaCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                           UpdateJanparaCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                           UpdateJanparaCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                UpdateJanparaCrawlSettingExcludeProductResultSuccessType
              when "UpdateJanparaCrawlSettingExcludeProductResultErrorType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                UpdateJanparaCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected UpdateJanparaCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
