module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeProduct
          class UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess < Base
            implements Interfaces::ResultBase

            field :yahoo_auction_crawl_setting_exclude_product,
                  Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingExcludeProduct, null: false
          end
        end
      end
    end
  end
end
