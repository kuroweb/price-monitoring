module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeKeyword
          class CreateJanparaCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                           CreateJanparaCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                CreateJanparaCrawlSettingExcludeKeywordResultValidationFailedType
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
