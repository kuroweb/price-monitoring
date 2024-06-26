module GraphqlSchema
  module Objects
    class MutationType < Base # rubocop:disable Metrics/ClassLength
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
      field :create_janpara_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword
      field :update_janpara_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword
      field :delete_janpara_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword
      field :create_janpara_crawl_setting_required_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword
      field :update_janpara_crawl_setting_required_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword
      field :delete_janpara_crawl_setting_required_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword
      field :create_janpara_crawl_setting_exclude_product,
            mutation: Mutations::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct
      field :update_janpara_crawl_setting_exclude_product,
            mutation: Mutations::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProduct
      field :delete_janpara_crawl_setting_exclude_product,
            mutation: Mutations::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct
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
      field :create_pc_koubou_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeyword
      field :update_pc_koubou_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeyword
      field :delete_pc_koubou_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeyword
      field :create_pc_koubou_crawl_setting_required_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeyword
      field :update_pc_koubou_crawl_setting_required_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword
      field :delete_pc_koubou_crawl_setting_required_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword
      field :create_pc_koubou_crawl_setting_exclude_product,
            mutation: Mutations::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProduct
      field :update_pc_koubou_crawl_setting_exclude_product,
            mutation: Mutations::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProduct
      field :delete_pc_koubou_crawl_setting_exclude_product,
            mutation: Mutations::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProduct
      field :create_used_sofmap_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword
      field :update_used_sofmap_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword
      field :delete_used_sofmap_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword
      field :create_used_sofmap_crawl_setting_required_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword
      field :update_used_sofmap_crawl_setting_required_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword
      field :delete_used_sofmap_crawl_setting_required_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword
      field :create_used_sofmap_crawl_setting_exclude_product,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct
      field :update_used_sofmap_crawl_setting_exclude_product,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProduct
      field :delete_used_sofmap_crawl_setting_exclude_product,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct
      field :create_category, mutation: Mutations::Categories::CreateCategory
      field :delete_category, mutation: Mutations::Categories::DeleteCategory
    end
  end
end
