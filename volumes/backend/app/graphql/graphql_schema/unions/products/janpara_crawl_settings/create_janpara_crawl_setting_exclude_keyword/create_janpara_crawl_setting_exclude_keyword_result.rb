module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeKeyword
          class CreateJanparaCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                           CreateJanparaCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                           CreateJanparaCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                CreateJanparaCrawlSettingExcludeKeywordResultSuccess
              when "CreateJanparaCrawlSettingExcludeKeywordResultError"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                CreateJanparaCrawlSettingExcludeKeywordResultError
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
