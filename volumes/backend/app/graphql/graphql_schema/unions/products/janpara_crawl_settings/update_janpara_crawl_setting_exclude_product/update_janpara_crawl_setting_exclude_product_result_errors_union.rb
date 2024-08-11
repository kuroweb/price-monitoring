module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeProduct
          class UpdateJanparaCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                           UpdateJanparaCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct::
                UpdateJanparaCrawlSettingExcludeProductResultValidationFailed
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
