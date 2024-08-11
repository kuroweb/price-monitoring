module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingRequiredKeyword
          class DeleteJanparaCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                           DeleteJanparaCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                           DeleteJanparaCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                DeleteJanparaCrawlSettingRequiredKeywordResultSuccessType
              when "DeleteJanparaCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                DeleteJanparaCrawlSettingRequiredKeywordResultErrorType
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
