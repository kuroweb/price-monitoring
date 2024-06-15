module GraphqlSchema
  module Unions
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeProduct
          class CreateJanparaCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                           CreateJanparaCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                           CreateJanparaCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateJanparaCrawlSettingExcludeProductResultSuccess"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                CreateJanparaCrawlSettingExcludeProductResultSuccess
              when "CreateJanparaCrawlSettingExcludeProductResultError"
                Objects::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                CreateJanparaCrawlSettingExcludeProductResultError
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
