module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeProduct
          class UpdateYahooAuctionCrawlSettingExcludeProductResultSuccessType < Base
            implements Interfaces::ResultBase

            field :yahoo_auction_crawl_setting_exclude_product,
                  Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingExcludeProductType, null: false
          end
        end
      end
    end
  end
end
