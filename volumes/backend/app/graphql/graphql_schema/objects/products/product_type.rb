module GraphqlSchema
  module Objects
    module Products
      class ProductType < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :name, String, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        field :yahoo_auction_crawl_setting, YahooAuctionCrawlSettings::YahooAuctionCrawlSetting, null: false
        field :mercari_crawl_setting, MercariCrawlSettings::MercariCrawlSettingType, null: false
        field :janpara_crawl_setting, JanparaCrawlSettings::JanparaCrawlSettingType, null: false
        field :iosys_crawl_setting, IosysCrawlSettings::IosysCrawlSettingType, null: false
        field :pc_koubou_crawl_setting, PcKoubouCrawlSettings::PcKoubouCrawlSetting, null: false
        field :used_sofmap_crawl_setting, UsedSofmapCrawlSettings::UsedSofmapCrawlSetting, null: false
        field :yahoo_auction_daily_purchase_summaries, [YahooAuctionDailyPurchaseSummaryType], null: false
        field :yahoo_fleamarket_daily_purchase_summaries, [YahooFleamarketDailyPurchaseSummaryType], null: false
        field :mercari_daily_purchase_summaries, [MercariDailyPurchaseSummaryType], null: false
        field :related_products, resolver: Resolvers::Products::RelatedProducts
        field :category, Categories::CategoryType, null: false

        delegate :yahoo_auction_crawl_setting, to: :object
        delegate :mercari_crawl_setting, to: :object
        delegate :janpara_crawl_setting, to: :object
        delegate :iosys_crawl_setting, to: :object
        delegate :pc_koubou_crawl_setting, to: :object
        delegate :used_sofmap_crawl_setting, to: :object
        delegate :yahoo_auction_daily_purchase_summaries, to: :object
        delegate :yahoo_fleamarket_daily_purchase_summaries, to: :object
        delegate :mercari_daily_purchase_summaries, to: :object
        delegate :category, to: :object
      end
    end
  end
end
