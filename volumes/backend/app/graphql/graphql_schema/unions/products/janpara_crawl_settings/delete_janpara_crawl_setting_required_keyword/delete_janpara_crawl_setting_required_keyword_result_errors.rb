module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingRequiredKeyword
          class DeleteJanparaCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                           DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailedType
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
