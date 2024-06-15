module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingRequiredKeyword
          class UpdateJanparaCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                           UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailed
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
