module GraphqlSchema
  module InputObjects
    module Products
      module UpdateProduct
        class UpdateProductInput < Base
          argument :id, ID, required: true
          argument :name, String, required: true
          argument :yahoo_auction_crawl_setting, UpdateProduct::YahooAuctionCrawlSettingInput, required: true
          argument :mercari_crawl_setting, UpdateProduct::MercariCrawlSettingInput, required: true
          argument :janpara_crawl_setting, UpdateProduct::JanparaCrawlSettingInput, required: true
          argument :iosys_crawl_setting, UpdateProduct::IosysCrawlSettingInput, required: true
          argument :pc_koubou_crawl_setting, UpdateProduct::PcKoubouCrawlSettingInput, required: true
          argument :used_sofmap_crawl_setting, UpdateProduct::UsedSofmapCrawlSettingInput, required: true
        end
      end
    end
  end
end
