module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                           CreateJanparaCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                CreateJanparaCrawlSettingRequiredKeywordResultValidationFailedType
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
