module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeProduct
          class DeleteJanparaCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                           DeleteJanparaCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteJanparaCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                DeleteJanparaCrawlSettingExcludeProductResultValidationFailedType
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
