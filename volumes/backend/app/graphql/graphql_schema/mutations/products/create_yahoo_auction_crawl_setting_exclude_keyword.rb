module GraphqlSchema
  module Mutations
    module Products
      class CreateYahooAuctionCrawlSettingExcludeKeyword < Base
        input_object_class InputObjects::Products::CreateYahooAuctionCrawlSettingExcludeKeywordInput

        field :result, Unions::Products::CreateYahooAuctionCrawlSettingExcludeKeywordResult, null: false

        type Unions::Products::CreateYahooAuctionCrawlSettingExcludeKeywordResult

        def resolve(input)
          product = Product.find(input[:product_id])
          yahoo_auction_crawl_setting_exclude_keyword =
            product
            .yahoo_auction_crawl_setting
            .yahoo_auction_crawl_setting_exclude_keywords
            .create!(keyword: input[:keyword])

          {
            __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess",
            yahoo_auction_crawl_setting_exclude_keyword:,
            ok: true
          }
        rescue StandardError => e
          handle_error(e)
        end

        private

        # rubocop:disable Metrics/MethodLength
        def handle_error(exception)
          case exception
          when ActiveRecord::RecordNotUnique
            {
              __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultError",
              error: {
                __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed",
                code: "409",
                message: "Conflict.",
                details: []
              },
              ok: false
            }
          when ActiveRecord::RecordInvalid
            Rails.logger.error("Bad Request. exception: #{exception.full_message}")

            {
              __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultError",
              error: {
                __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed",
                code: "400",
                message: "Bad Request.",
                details: []
              },
              ok: false
            }
          else
            Rails.logger.error("Bad Request. exception: #{exception.full_message}")

            {
              __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultError",
              error: {
                __typename: "CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed",
                code: "503",
                message: "Internal Server Error.",
                details: []
              },
              ok: false
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
