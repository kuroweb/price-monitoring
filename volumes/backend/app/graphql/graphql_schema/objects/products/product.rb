module GraphqlSchema
  module Objects
    module Products
      class Product < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :name, String, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        field :yahoo_auction_crawl_setting, YahooAuctionCrawlSettings::YahooAuctionCrawlSetting, null: false
        field :mercari_crawl_setting, MercariCrawlSettings::MercariCrawlSetting, null: false
        field :janpara_crawl_setting, JanparaCrawlSettings::JanparaCrawlSetting, null: false
        field :iosys_crawl_setting, IosysCrawlSettings::IosysCrawlSetting, null: false
        field :pc_koubou_crawl_setting, PcKoubouCrawlSettings::PcKoubouCrawlSetting, null: false
        field :used_sofmap_crawl_setting, UsedSofmapCrawlSettings::UsedSofmapCrawlSetting, null: false
        field :yahoo_auction_daily_purchase_summaries, [YahooAuctionDailyPurchaseSummary], null: false
        field :yahoo_fleamarket_daily_purchase_summaries, [YahooFleamarketDailyPurchaseSummary], null: false
        field :mercari_daily_purchase_summaries, [MercariDailyPurchaseSummary], null: false
        field :related_products, resolver: Resolvers::Products::RelatedProducts

        def yahoo_auction_crawl_setting
          object.yahoo_auction_crawl_setting
        end

        def mercari_crawl_setting
          object.mercari_crawl_setting
        end

        def janpara_crawl_setting
          object.janpara_crawl_setting
        end

        def iosys_crawl_setting
          object.iosys_crawl_setting
        end

        def pc_koubou_crawl_setting
          object.pc_koubou_crawl_setting
        end

        def used_sofmap_crawl_setting
          object.used_sofmap_crawl_setting
        end

        def yahoo_auction_daily_purchase_summaries
          object.yahoo_auction_daily_purchase_summaries
        end

        def yahoo_fleamarket_daily_purchase_summaries
          object.yahoo_fleamarket_daily_purchase_summaries
        end

        def mercari_daily_purchase_summaries
          object.mercari_daily_purchase_summaries
        end
      end
    end
  end
end
