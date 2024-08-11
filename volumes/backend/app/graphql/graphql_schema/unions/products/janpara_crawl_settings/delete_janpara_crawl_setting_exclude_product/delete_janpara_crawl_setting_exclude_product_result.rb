module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeProduct
          class DeleteJanparaCrawlSettingExcludeProductResult < Base
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
                raise "Unexpected DeleteJanparaCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
