module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeKeyword
          class UpdateJanparaCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                           UpdateJanparaCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                           UpdateJanparaCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateJanparaCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                UpdateJanparaCrawlSettingExcludeKeywordResultSuccess
              when "UpdateJanparaCrawlSettingExcludeKeywordResultError"
                Objects::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                UpdateJanparaCrawlSettingExcludeKeywordResultError
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
