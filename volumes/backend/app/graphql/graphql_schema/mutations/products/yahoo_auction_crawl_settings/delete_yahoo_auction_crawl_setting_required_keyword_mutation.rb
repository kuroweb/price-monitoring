module GraphqlSchema
  module Mutations
    module Products
      module YahooAuctionCrawlSettings
        class DeleteYahooAuctionCrawlSettingRequiredKeywordMutation < Base
          input_object_class InputObjects::Products::YahooAuctionCrawlSettings::
                             DeleteYahooAuctionCrawlSettingRequiredKeywordInput

          type Unions::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
               DeleteYahooAuctionCrawlSettingRequiredKeywordResult, null: false

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            yahoo_auction_crawl_setting_required_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_required_keywords
              .find(input[:id])

            if yahoo_auction_crawl_setting_required_keyword.destroy
              {
                __typename: "DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccessType",
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
              __typename: "DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrorType",
              error: {
                __typename: "DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType",
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
