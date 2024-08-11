module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeKeyword
          class UpdateJanparaCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                           UpdateJanparaCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                           UpdateJanparaCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                UpdateJanparaCrawlSettingExcludeKeywordResultSuccessType
              when "UpdateJanparaCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                UpdateJanparaCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected UpdateJanparaCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
