module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingRequiredKeyword
          class UpdateJanparaCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                           UpdateJanparaCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                           UpdateJanparaCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                UpdateJanparaCrawlSettingRequiredKeywordResultSuccess
              when "UpdateJanparaCrawlSettingRequiredKeywordResultError"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                UpdateJanparaCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected UpdateJanparaCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
