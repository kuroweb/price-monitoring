module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingRequiredKeyword
          class UpdateJanparaCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                           UpdateJanparaCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                           UpdateJanparaCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                UpdateJanparaCrawlSettingRequiredKeywordResultSuccessType
              when "UpdateJanparaCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                UpdateJanparaCrawlSettingRequiredKeywordResultErrorType
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
