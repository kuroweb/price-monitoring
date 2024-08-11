module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingRequiredKeyword
          class UpdateJanparaCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                           UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailedType
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
