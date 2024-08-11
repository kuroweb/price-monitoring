module GraphqlSchema
  module Mutations
    module Products
      module MercariCrawlSettings
        class UpdateMercariCrawlSettingExcludeProduct < Base
          input_object_class InputObjects::Products::MercariCrawlSettings::
                             UpdateMercariCrawlSettingExcludeProductInput

          type Unions::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
               UpdateMercariCrawlSettingExcludeProductResult, null: false

          def resolve(input)
            product = Product.find(input[:product_id])
            mercari_crawl_setting_exclude_product =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_exclude_products
              .find(input[:id])
            mercari_crawl_setting_exclude_product.update!(external_id: input[:external_id])

            inspect(product)

            {
              __typename: "UpdateMercariCrawlSettingExcludeProductResultSuccessType",
              mercari_crawl_setting_exclude_product:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspect::DeleteMercariProducts.call(product:)
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
              __typename: "UpdateMercariCrawlSettingExcludeProductResultErrorType",
              error: {
                __typename: "UpdateMercariCrawlSettingExcludeProductResultValidationFailedType",
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
