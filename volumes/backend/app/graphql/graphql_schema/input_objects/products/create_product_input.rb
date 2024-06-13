module GraphqlSchema
  module InputObjects
    module Products
      class CreateProductInput < Base
        argument :name, String, required: true
        argument :yahoo_auction_crawl_setting, CreateYahooAuctionCrawlSettingInput, required: true
        argument :mercari_crawl_setting, CreateMercariCrawlSettingInput, required: true
        argument :janpara_crawl_setting, CreateJanparaCrawlSettingInput, required: true
        argument :iosys_crawl_setting, CreateIosysCrawlSettingInput, required: true
        argument :pc_koubou_crawl_setting, CreatePcKoubouCrawlSettingInput, required: true
        argument :used_sofmap_crawl_setting, CreateUsedSofmapCrawlSettingInput, required: true
      end
    end
  end
end
