module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeProduct
          class CreateJanparaCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                           CreateJanparaCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                           CreateJanparaCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                CreateJanparaCrawlSettingExcludeProductResultSuccessType
              when "CreateJanparaCrawlSettingExcludeProductResultErrorType"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                CreateJanparaCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected CreateJanparaCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
