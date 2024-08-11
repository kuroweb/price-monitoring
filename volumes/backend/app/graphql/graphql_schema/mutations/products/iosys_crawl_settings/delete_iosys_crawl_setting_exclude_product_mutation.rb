module GraphqlSchema
  module Mutations
    module Products
      module IosysCrawlSettings
        class DeleteIosysCrawlSettingExcludeProductMutation < Base
          input_object_class InputObjects::Products::IosysCrawlSettings::
                             DeleteIosysCrawlSettingExcludeProductInput

          type Unions::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
               DeleteIosysCrawlSettingExcludeProductResultUnion, null: false

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            iosys_crawl_setting_exclude_product =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_exclude_products
              .find(input[:id])

            if iosys_crawl_setting_exclude_product.destroy
              {
                __typename: "DeleteIosysCrawlSettingExcludeProductResultSuccessType",
                ok: true
              }
            else
              error_response("400", "Bad Request.")
            end
          rescue StandardError => e
            handle_error(e)
          end

          private

          def handle_error(exception)
            case exception
            when ActiveRecord::RecordNotFound
              error_response("404", "Not Found.")
            else
              Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
              error_response("503", "Internal Server Error.")
            end
          end

          def error_response(code, message)
            {
              __typename: "DeleteIosysCrawlSettingExcludeProductResultErrorType",
              error: {
                __typename: "DeleteIosysCrawlSettingExcludeProductResultValidationFailedType",
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
