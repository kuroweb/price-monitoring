module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                           CreateJanparaCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                           CreateJanparaCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                CreateJanparaCrawlSettingRequiredKeywordResultSuccess
              when "CreateJanparaCrawlSettingRequiredKeywordResultError"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                CreateJanparaCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected CreateJanparaCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
