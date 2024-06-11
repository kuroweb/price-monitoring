module GraphqlSchema
  module InputObjects
    module Products
      class CreateProduct < Base
        argument :name, String, required: true
        argument :yahoo_auction_crawl_setting, CreateYahooAuctionCrawlSetting, required: true
        argument :mercari_crawl_setting, CreateMercariCrawlSetting, required: true
        argument :janpara_crawl_setting, CreateJanparaCrawlSetting, required: true
        argument :iosys_crawl_setting, CreateIosysCrawlSetting, required: true
        argument :pc_koubou_crawl_setting, CreatePcKoubouCrawlSetting, required: true
        argument :used_sofmap_crawl_setting, CreateUsedSofmapCrawlSetting, required: true
      end
    end
  end
end
