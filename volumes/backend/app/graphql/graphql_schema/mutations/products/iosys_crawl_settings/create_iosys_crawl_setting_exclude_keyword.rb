module GraphqlSchema
  module Mutations
    module Products
      module IosysCrawlSettings
        class CreateIosysCrawlSettingExcludeKeyword < Base
          input_object_class InputObjects::Products::IosysCrawlSettings::
                             CreateIosysCrawlSettingExcludeKeywordInput

          type Unions::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
               CreateIosysCrawlSettingExcludeKeywordResult, null: false

          def resolve(input)
            product = Product.find(input[:product_id])
            iosys_crawl_setting_exclude_keyword =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_exclude_keywords
              .create!(keyword: input[:keyword])

            inspect(product)

            {
              __typename: "CreateIosysCrawlSettingExcludeKeywordResultSuccessType",
              iosys_crawl_setting_exclude_keyword:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspector::InspectIosysProducts.call(product:)
          end

          def handle_error(exception)
            case exception
            when ActiveRecord::RecordInvalid
              Rails.logger.error("Bad Request. exception: #{exception.full_message}")
              error_response("400", "Bad Request.")
            when ActiveRecord::RecordNotFound
              error_response("404", "Not Found.")
            when ActiveRecord::RecordNotUnique
              error_response("409", "Conflict.")
            else
              Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
              error_response("503", "Internal Server Error.")
            end
          end

          def error_response(code, message)
            {
              __typename: "CreateIosysCrawlSettingExcludeKeywordResultErrorType",
              error: {
                __typename: "CreateIosysCrawlSettingExcludeKeywordResultValidationFailedType",
                code:,
                message:,
                details: []
              },
              ok: false
            }
          end
        end
      end
    end
  end
end
