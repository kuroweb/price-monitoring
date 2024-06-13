module GraphqlSchema
  module InputObjects
    module Products
      class UpdateProductInput < Base
        argument :id, ID, required: true
        argument :name, String, required: true
        argument :yahoo_auction_crawl_setting, UpdateYahooAuctionCrawlSettingInput, required: true
        argument :mercari_crawl_setting, UpdateMercariCrawlSettingInput, required: true
        argument :janpara_crawl_setting, UpdateJanparaCrawlSettingInput, required: true
        argument :iosys_crawl_setting, UpdateIosysCrawlSettingInput, required: true
        argument :pc_koubou_crawl_setting, UpdatePcKoubouCrawlSettingInput, required: true
        argument :used_sofmap_crawl_setting, UpdateUsedSofmapCrawlSettingInput, required: true
      end
    end
  end
end
