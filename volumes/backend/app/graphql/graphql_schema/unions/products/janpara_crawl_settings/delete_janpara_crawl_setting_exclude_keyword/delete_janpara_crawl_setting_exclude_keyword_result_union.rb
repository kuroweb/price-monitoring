module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeKeyword
          class DeleteJanparaCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                           DeleteJanparaCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                           DeleteJanparaCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                DeleteJanparaCrawlSettingExcludeKeywordResultSuccessType
              when "DeleteJanparaCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                DeleteJanparaCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected DeleteJanparaCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
