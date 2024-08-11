module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeProduct
          class DeleteJanparaCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                           DeleteJanparaCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                           DeleteJanparaCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                DeleteJanparaCrawlSettingExcludeProductResultSuccessType
              when "DeleteJanparaCrawlSettingExcludeProductResultErrorType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                DeleteJanparaCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected DeleteJanparaCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
