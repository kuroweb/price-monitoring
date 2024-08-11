module GraphqlSchema
  module Unions
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeKeyword
          class CreateIosysCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                           CreateIosysCrawlSettingExcludeKeywordResultValidationFailed

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateIosysCrawlSettingExcludeKeywordResultValidationFailed"
                Objects::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                CreateIosysCrawlSettingExcludeKeywordResultValidationFailed
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
