module GraphqlSchema
  module Objects
    class MutationType < Base # rubocop:disable Metrics/ClassLength
      field :create_product, mutation: Mutations::Products::CreateProductMutation
      field :update_product, mutation: Mutations::Products::UpdateProductMutation
      field :delete_product, mutation: Mutations::Products::DeleteProductMutation
      field :create_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      CreateYahooAuctionCrawlSettingExcludeKeywordMutation
      field :update_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      UpdateYahooAuctionCrawlSettingExcludeKeywordMutation
      field :delete_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      DeleteYahooAuctionCrawlSettingExcludeKeywordMutation
      field :create_yahoo_auction_crawl_setting_required_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      CreateYahooAuctionCrawlSettingRequiredKeywordMutation
      field :update_yahoo_auction_crawl_setting_required_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      UpdateYahooAuctionCrawlSettingRequiredKeywordMutation
      field :delete_yahoo_auction_crawl_setting_required_keyword,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      DeleteYahooAuctionCrawlSettingRequiredKeywordMutation
      field :create_yahoo_auction_crawl_setting_exclude_product,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      CreateYahooAuctionCrawlSettingExcludeProductMutation
      field :update_yahoo_auction_crawl_setting_exclude_product,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      UpdateYahooAuctionCrawlSettingExcludeProductMutation
      field :delete_yahoo_auction_crawl_setting_exclude_product,
            mutation: Mutations::Products::YahooAuctionCrawlSettings::
                      DeleteYahooAuctionCrawlSettingExcludeProductMutation
      field :create_mercari_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeywordMutation
      field :update_mercari_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeywordMutation
      field :delete_mercari_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeywordMutation
      field :create_mercari_crawl_setting_required_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::CreateMercariCrawlSettingRequiredKeywordMutation
      field :update_mercari_crawl_setting_required_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeywordMutation
      field :delete_mercari_crawl_setting_required_keyword,
            mutation: Mutations::Products::MercariCrawlSettings::DeleteMercariCrawlSettingRequiredKeywordMutation
      field :create_mercari_crawl_setting_exclude_product,
            mutation: Mutations::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProductMutation
      field :update_mercari_crawl_setting_exclude_product,
            mutation: Mutations::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProductMutation
      field :delete_mercari_crawl_setting_exclude_product,
            mutation: Mutations::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProductMutation
      field :create_janpara_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeywordMutation
      field :update_janpara_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeywordMutation
      field :delete_janpara_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeywordMutation
      field :create_janpara_crawl_setting_required_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeywordMutation
      field :update_janpara_crawl_setting_required_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeywordMutation
      field :delete_janpara_crawl_setting_required_keyword,
            mutation: Mutations::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeywordMutation
      field :create_janpara_crawl_setting_exclude_product,
            mutation: Mutations::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProductMutation
      field :update_janpara_crawl_setting_exclude_product,
            mutation: Mutations::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeProductMutation
      field :delete_janpara_crawl_setting_exclude_product,
            mutation: Mutations::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProductMutation
      field :create_iosys_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeywordMutation
      field :update_iosys_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeywordMutation
      field :delete_iosys_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeywordMutation
      field :create_iosys_crawl_setting_required_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeywordMutation
      field :update_iosys_crawl_setting_required_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeywordMutation
      field :delete_iosys_crawl_setting_required_keyword,
            mutation: Mutations::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeywordMutation
      field :create_iosys_crawl_setting_exclude_product,
            mutation: Mutations::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProductMutation
      field :update_iosys_crawl_setting_exclude_product,
            mutation: Mutations::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeProductMutation
      field :delete_iosys_crawl_setting_exclude_product,
            mutation: Mutations::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProductMutation
      field :create_pc_koubou_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeKeywordMutation
      field :update_pc_koubou_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeKeywordMutation
      field :delete_pc_koubou_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeKeywordMutation
      field :create_pc_koubou_crawl_setting_required_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingRequiredKeywordMutation
      field :update_pc_koubou_crawl_setting_required_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeywordMutation
      field :delete_pc_koubou_crawl_setting_required_keyword,
            mutation: Mutations::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeywordMutation
      field :create_pc_koubou_crawl_setting_exclude_product,
            mutation: Mutations::Products::PcKoubouCrawlSettings::CreatePcKoubouCrawlSettingExcludeProductMutation
      field :update_pc_koubou_crawl_setting_exclude_product,
            mutation: Mutations::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingExcludeProductMutation
      field :delete_pc_koubou_crawl_setting_exclude_product,
            mutation: Mutations::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingExcludeProductMutation
      field :create_used_sofmap_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeywordMutation
      field :update_used_sofmap_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeywordMutation
      field :delete_used_sofmap_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeywordMutation
      field :create_used_sofmap_crawl_setting_required_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeywordMutation
      field :update_used_sofmap_crawl_setting_required_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeywordMutation
      field :delete_used_sofmap_crawl_setting_required_keyword,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeywordMutation
      field :create_used_sofmap_crawl_setting_exclude_product,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProductMutation
      field :update_used_sofmap_crawl_setting_exclude_product,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeProductMutation
      field :delete_used_sofmap_crawl_setting_exclude_product,
            mutation: Mutations::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProductMutation
      field :create_category, mutation: Mutations::Categories::CreateCategoryMutation
      field :delete_category, mutation: Mutations::Categories::DeleteCategoryMutation
    end
  end
end
