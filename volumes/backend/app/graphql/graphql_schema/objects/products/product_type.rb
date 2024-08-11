module GraphqlSchema
  module Objects
    module Products
      class ProductType < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :name, String, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        field :yahoo_auction_crawl_setting, YahooAuctionCrawlSettings::YahooAuctionCrawlSettingType, null: false
        field :mercari_crawl_setting, MercariCrawlSettings::MercariCrawlSettingType, null: false
        field :janpara_crawl_setting, JanparaCrawlSettings::JanparaCrawlSettingType, null: false
        field :iosys_crawl_setting, IosysCrawlSettings::IosysCrawlSettingType, null: false
        field :pc_koubou_crawl_setting, PcKoubouCrawlSettings::PcKoubouCrawlSettingType, null: false
        field :used_sofmap_crawl_setting, UsedSofmapCrawlSettings::UsedSofmapCrawlSettingType, null: false
        field :yahoo_auction_daily_purchase_summaries, [YahooAuctionDailyPurchaseSummaryType], null: false
        field :yahoo_fleamarket_daily_purchase_summaries, [YahooFleamarketDailyPurchaseSummaryType], null: false
        field :mercari_daily_purchase_summaries, [MercariDailyPurchaseSummaryType], null: false
        field :related_products, resolver: Resolvers::Products::RelatedProductsResolver
        field :category, Categories::CategoryType, null: false

        delegate :yahoo_auction_crawl_setting,
                 :mercari_crawl_setting,
                 :janpara_crawl_setting,
                 :iosys_crawl_setting,
                 :pc_koubou_crawl_setting,
                 :used_sofmap_crawl_setting,
                 :yahoo_auction_daily_purchase_summaries,
                 :yahoo_fleamarket_daily_purchase_summaries,
                 :mercari_daily_purchase_summaries,
                 :category, to: :object
      end
    end
  end
end
