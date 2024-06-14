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
      field :create_mercari_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword
      field :update_mercari_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword
      field :delete_mercari_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword
      field :create_mercari_crawl_setting_required_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeyword
      field :update_mercari_crawl_setting_required_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword
      field :delete_mercari_crawl_setting_required_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeyword
      field :create_mercari_crawl_setting_exclude_product,
            mutation: Mutations::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct
      field :update_mercari_crawl_setting_exclude_product,
            mutation: Mutations::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct
      field :delete_mercari_crawl_setting_exclude_product,
            mutation: Mutations::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct
      field :create_iosys_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword
      field :update_iosys_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword
      field :delete_iosys_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword
      field :create_iosys_crawl_setting_required_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword
      field :update_iosys_crawl_setting_required_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword
      field :delete_iosys_crawl_setting_required_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword
      field :create_iosys_crawl_setting_exclude_product,
            mutation: Mutations::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct
      field :update_iosys_crawl_setting_exclude_product,
            mutation: Mutations::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProduct
      field :delete_iosys_crawl_setting_exclude_product,
            mutation: Mutations::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct
    end
  end
end
