module GraphqlSchema
  module InputObjects
    module Products
      class UpdateProduct < Base
        argument :id, ID, required: true
        argument :name, String, required: true
        argument :yahoo_auction_crawl_setting, UpdateYahooAuctionCrawlSetting, required: true
        argument :mercari_crawl_setting, UpdateMercariCrawlSetting, required: true
        argument :janpara_crawl_setting, UpdateJanparaCrawlSetting, required: true
        argument :iosys_crawl_setting, UpdateIosysCrawlSetting, required: true
        argument :pc_koubou_crawl_setting, UpdatePcKoubouCrawlSetting, required: true
        argument :used_sofmap_crawl_setting, UpdateUsedSofmapCrawlSetting, required: true
      end
    end
  end
end
