module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                           CreateJanparaCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                CreateJanparaCrawlSettingRequiredKeywordResultValidationFailed
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
