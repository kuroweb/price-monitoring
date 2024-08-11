module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeProduct
          class CreateJanparaCrawlSettingExcludeProductResultErrorsUnion < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                           CreateJanparaCrawlSettingExcludeProductResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingExcludeProductResultValidationFailed"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                CreateJanparaCrawlSettingExcludeProductResultValidationFailed
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
