module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingRequiredKeyword
        class CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess < Base
          implements Interfaces::Products::ResultBase

          field :yahoo_auction_crawl_setting_required_keyword,
                Objects::Products::YahooAuctionCrawlSettingRequiredKeyword,
                null: false
        end
      end
    end
  end
end
