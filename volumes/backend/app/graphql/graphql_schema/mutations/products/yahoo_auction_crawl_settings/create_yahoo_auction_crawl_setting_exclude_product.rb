module GraphqlSchema
  module Mutations
    module Products
      module YahooAuctionCrawlSettings
        class CreateYahooAuctionCrawlSettingExcludeProduct < Base
          input_object_class InputObjects::Products::YahooAuctionCrawlSettings::
                             CreateYahooAuctionCrawlSettingExcludeProductInput

          type Unions::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
               CreateYahooAuctionCrawlSettingExcludeProductResult, null: false

          def resolve(input)
            product = Product.find(input[:product_id])
            yahoo_auction_crawl_setting_exclude_product =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_products
              .create!(external_id: input[:external_id])

            inspect(product)

            {
              __typename: "CreateYahooAuctionCrawlSettingExcludeProductResultSuccessType",
              yahoo_auction_crawl_setting_exclude_product:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspect::DeleteYahooAuctionProducts.call(product:)
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
              __typename: "CreateYahooAuctionCrawlSettingExcludeProductResultErrorType",
              error: {
                __typename: "CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType",
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
