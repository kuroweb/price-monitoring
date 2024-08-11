module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                           CreateJanparaCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                           CreateJanparaCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                CreateJanparaCrawlSettingRequiredKeywordResultSuccessType
              when "CreateJanparaCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                CreateJanparaCrawlSettingRequiredKeywordResultErrorType
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
