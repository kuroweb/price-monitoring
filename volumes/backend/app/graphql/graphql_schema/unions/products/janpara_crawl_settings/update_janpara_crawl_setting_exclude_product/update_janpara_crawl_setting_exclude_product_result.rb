module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeProduct
          class UpdateJanparaCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                           UpdateJanparaCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                           UpdateJanparaCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingExcludeProductResultSuccess"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                UpdateJanparaCrawlSettingExcludeProductResultSuccess
              when "UpdateJanparaCrawlSettingExcludeProductResultError"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                UpdateJanparaCrawlSettingExcludeProductResultError
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
