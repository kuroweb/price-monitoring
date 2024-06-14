module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResultErrors < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                           CreateIosysCrawlSettingRequiredKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingRequiredKeywordResultValidationFailed"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                CreateIosysCrawlSettingRequiredKeywordResultValidationFailed
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
