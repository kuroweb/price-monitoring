module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeProduct
          class DeleteJanparaCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                           DeleteJanparaCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                           DeleteJanparaCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingExcludeProductResultSuccess"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                DeleteJanparaCrawlSettingExcludeProductResultSuccess
              when "DeleteJanparaCrawlSettingExcludeProductResultError"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                DeleteJanparaCrawlSettingExcludeProductResultError
              else
                raise "Unexpected DeleteJanparaCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
