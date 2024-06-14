module GraphqlSchema
  module Mutations
    module Products
      module IosysCrawlSettings
        class UpdateIosysCrawlSettingRequiredKeyword < Base
          input_object_class InputObjects::Products::IosysCrawlSettings::
                             UpdateIosysCrawlSettingRequiredKeywordInput

          field :result,
                Unions::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                UpdateIosysCrawlSettingRequiredKeywordResult,
                null: false

          type Unions::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
               UpdateIosysCrawlSettingRequiredKeywordResult

          def resolve(input)
            product = Product.find(input[:product_id])
            iosys_crawl_setting_required_keyword =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_required_keywords
              .find(input[:id])
            iosys_crawl_setting_required_keyword.update!(keyword: input[:keyword])

            inspect(product)

            {
              __typename: "UpdateIosysCrawlSettingRequiredKeywordResultSuccess",
              iosys_crawl_setting_required_keyword:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspect::DeleteIosysProducts.call(product:)
            ::Products::Inspect::DeleteYahooFleamarketProducts.call(product:)
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
              __typename: "UpdateIosysCrawlSettingRequiredKeywordResultError",
              error: {
                __typename: "UpdateIosysCrawlSettingRequiredKeywordResultValidationFailed",
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
