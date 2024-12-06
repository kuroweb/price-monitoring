module GraphqlSchema
  module Mutations
    module Products
      module YahooAuctionCrawlSettings
        class UpdateYahooAuctionCrawlSettingExcludeProduct < Base
          input_object_class InputObjects::Products::YahooAuctionCrawlSettings::
                             UpdateYahooAuctionCrawlSettingExcludeProductInput

          type Unions::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
               UpdateYahooAuctionCrawlSettingExcludeProductResult, null: false

          def resolve(input)
            product = Product.find(input[:product_id])
            yahoo_auction_crawl_setting_exclude_product =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_products
              .find(input[:id])
            yahoo_auction_crawl_setting_exclude_product.update!(external_id: input[:external_id])

            inspect(product)

            {
              __typename: "UpdateYahooAuctionCrawlSettingExcludeProductResultSuccessType",
              yahoo_auction_crawl_setting_exclude_product:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspector::InspectYahooAuctionProducts.call(product:)
            ::Products::Inspector::InspectYahooFleamarketProducts.call(product:)
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
              __typename: "UpdateYahooAuctionCrawlSettingExcludeProductResultErrorType",
              error: {
                __typename: "UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType",
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
