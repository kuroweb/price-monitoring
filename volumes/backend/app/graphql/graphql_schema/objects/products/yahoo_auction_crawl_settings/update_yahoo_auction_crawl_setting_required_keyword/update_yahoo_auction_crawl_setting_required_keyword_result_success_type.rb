module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingRequiredKeyword
          class UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :yahoo_auction_crawl_setting_required_keyword,
                  Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingRequiredKeywordType, null: false
          end
        end
      end
    end
  end
end
