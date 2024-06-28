module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingRequiredKeyword
          class DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :yahoo_auction_crawl_setting_required_keyword,
                  Objects::Products::YahooAuctionCrawlSettings::YahooAuctionCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
