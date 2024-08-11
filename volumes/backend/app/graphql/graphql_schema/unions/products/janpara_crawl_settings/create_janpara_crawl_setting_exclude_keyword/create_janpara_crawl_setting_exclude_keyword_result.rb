module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeKeyword
          class CreateJanparaCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                           CreateJanparaCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                           CreateJanparaCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                CreateJanparaCrawlSettingExcludeKeywordResultSuccessType
              when "CreateJanparaCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                CreateJanparaCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected CreateJanparaCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
