module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingRequiredKeyword
          class UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :yahoo_auction_crawl_setting_required_keyword,
                  Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
