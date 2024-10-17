class ProductSerializer < BaseSerializer
  delegate(*Product.column_names, to: :product)

  attr_reader :product, :yahoo_auction_crawl_setting, :mercari_crawl_setting, :janpara_crawl_setting,
              :iosys_crawl_setting, :pc_koubou_crawl_setting, :used_sofmap_crawl_setting

  def initialize(product)
    @product = product
    @yahoo_auction_crawl_setting = YahooAuctionCrawlSettingSerializer.new(product.yahoo_auction_crawl_setting)
    @mercari_crawl_setting = MercariCrawlSettingSerializer.new(product.mercari_crawl_setting)
    @janpara_crawl_setting = JanparaCrawlSettingSerializer.new(product.janpara_crawl_setting)
    @iosys_crawl_setting = IosysCrawlSettingSerializer.new(product.iosys_crawl_setting)
    @pc_koubou_crawl_setting = PcKoubouCrawlSettingSerializer.new(product.pc_koubou_crawl_setting)
    @used_sofmap_crawl_setting = UsedSofmapCrawlSettingSerializer.new(product.used_sofmap_crawl_setting)
  end

  private

  def attribute_names
    Product.column_names + %w[
      yahoo_auction_crawl_setting
      mercari_crawl_setting
      janpara_crawl_setting
      iosys_crawl_setting
      pc_koubou_crawl_setting
      used_sofmap_crawl_setting
    ]
  end
end
