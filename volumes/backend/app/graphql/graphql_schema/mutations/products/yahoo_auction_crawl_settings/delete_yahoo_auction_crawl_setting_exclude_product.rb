module GraphqlSchema
  module Mutations
    module Products
      module YahooAuctionCrawlSettings
        class DeleteYahooAuctionCrawlSettingExcludeProduct < Base
          input_object_class InputObjects::Products::YahooAuctionCrawlSettings::
                             DeleteYahooAuctionCrawlSettingExcludeProductInput

          type Unions::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
               DeleteYahooAuctionCrawlSettingExcludeProductResultUnion, null: false

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            yahoo_auction_crawl_setting_exclude_product =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_products
              .find(input[:id])

            if yahoo_auction_crawl_setting_exclude_product.destroy
              {
                __typename: "DeleteYahooAuctionCrawlSettingExcludeProductResultSuccessType",
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
              __typename: "DeleteYahooAuctionCrawlSettingExcludeProductResultErrorType",
              error: {
                __typename: "DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailedType",
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
