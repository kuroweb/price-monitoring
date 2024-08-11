module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeProduct
          class UpdateJanparaCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                           UpdateJanparaCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                UpdateJanparaCrawlSettingExcludeProductResultValidationFailedType
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
