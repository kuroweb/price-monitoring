module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingRequiredKeyword
          class DeleteJanparaCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                           DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed
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
