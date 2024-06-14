module GraphqlSchema
  module Objects
    class MutationType < Base
      field :create_product, mutation: Mutations::Products::CreateProduct
      field :update_product, mutation: Mutations::Products::UpdateProduct
      field :delete_product, mutation: Mutations::Products::DeleteProduct
      field :create_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword
      field :update_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword
      field :delete_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword
      field :create_yahoo_auction_crawl_setting_required_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword
      field :update_yahoo_auction_crawl_setting_required_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword
      field :delete_yahoo_auction_crawl_setting_required_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword
      field :create_yahoo_auction_crawl_setting_exclude_product,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct
      field :update_yahoo_auction_crawl_setting_exclude_product,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct
      field :delete_yahoo_auction_crawl_setting_exclude_product,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct
    end
  end
end
