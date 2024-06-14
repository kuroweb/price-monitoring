module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingExcludeProduct
        class CreateYahooAuctionCrawlSettingExcludeProductResultSuccess < Base
          implements Interfaces::Products::ResultBase

          field :yahoo_auction_crawl_setting_exclude_keyword,
                Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingExcludeProduct,
                null: false
        end
      end
    end
  end
end
