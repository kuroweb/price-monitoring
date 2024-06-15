module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingRequiredKeyword
          class DeleteJanparaCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                           DeleteJanparaCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                           DeleteJanparaCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                DeleteJanparaCrawlSettingRequiredKeywordResultSuccess
              when "DeleteJanparaCrawlSettingRequiredKeywordResultError"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                DeleteJanparaCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected DeleteJanparaCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
