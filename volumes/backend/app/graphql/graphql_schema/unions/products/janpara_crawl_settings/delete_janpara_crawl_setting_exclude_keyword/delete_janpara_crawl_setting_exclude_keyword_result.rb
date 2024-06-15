module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeKeyword
          class DeleteJanparaCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                           DeleteJanparaCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                           DeleteJanparaCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                DeleteJanparaCrawlSettingExcludeKeywordResultSuccess
              when "DeleteJanparaCrawlSettingExcludeKeywordResultError"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                DeleteJanparaCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected DeleteJanparaCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
