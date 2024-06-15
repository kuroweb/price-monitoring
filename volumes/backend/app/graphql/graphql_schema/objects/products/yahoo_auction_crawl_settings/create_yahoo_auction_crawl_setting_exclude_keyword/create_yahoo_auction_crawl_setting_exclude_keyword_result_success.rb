module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeKeyword
          class CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :yahoo_auction_crawl_setting_exclude_keyword,
                  Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingExcludeKeyword,
                  null: false
          end
        end
      end
    end
  end
end