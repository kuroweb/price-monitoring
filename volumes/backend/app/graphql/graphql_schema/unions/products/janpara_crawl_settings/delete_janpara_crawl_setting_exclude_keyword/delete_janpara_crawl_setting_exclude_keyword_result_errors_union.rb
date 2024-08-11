module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeKeyword
          class DeleteJanparaCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                           DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailedType
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
