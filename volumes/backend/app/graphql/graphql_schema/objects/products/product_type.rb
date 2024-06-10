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
        field :related_products, [RelatedProductType], null: false do
          argument :platform_mask, String, required: true
          argument :page, Int, required: false
          argument :per, Int, required: false
          argument :sort, String, required: false
          argument :order, String, required: false
        end

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

        def related_products(platform_mask:, page: nil, per: nil, sort: nil, order: nil)
          Search::RetrieveRelatedProduct.call(
            params: {
              product_id: object.id,
              platform_mask:, page:, per:, sort:, order:
            }
          ).products
        end
      end
    end
  end
end
