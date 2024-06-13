module GraphqlSchema
  module Mutations
    module Products
      class UpdateYahooAuctionCrawlSettingRequiredKeyword < Base
        input_object_class InputObjects::Products::UpdateYahooAuctionCrawlSettingRequiredKeywordInput

        field :result, Unions::Products::UpdateYahooAuctionCrawlSettingRequiredKeywordResult, null: false

        type Unions::Products::UpdateYahooAuctionCrawlSettingRequiredKeywordResult

        def resolve(input)
          product = Product.find(input[:product_id])
          yahoo_auction_crawl_setting_required_keyword =
            product
            .yahoo_auction_crawl_setting
            .yahoo_auction_crawl_setting_required_keywords
            .find(input[:id])

          yahoo_auction_crawl_setting_required_keyword.update!(keyword: input[:keyword])

          {
            __typename: "UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess",
            yahoo_auction_crawl_setting_required_keyword:,
            ok: true
          }
        rescue StandardError => e
          handle_error(e)
        end

        private

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
            Rails.logger.error("Bad Request. exception: #{exception.full_message}")
            error_response("503", "Internal Server Error.")
          end
        end

        def error_response(code, message)
          {
            __typename: "UpdateYahooAuctionCrawlSettingRequiredKeywordResultError",
            error: {
              __typename: "UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed",
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
