module Api
  module Products
    class ProductListSerializer
      JSON_OPTIONS = {
        include: [
          yahoo_auction_crawl_setting: {
            include: %i[
              yahoo_auction_crawl_setting_exclude_keywords
              yahoo_auction_crawl_setting_required_keywords
            ]
          },
          mercari_crawl_setting: {
            include: %i[
              mercari_crawl_setting_exclude_keywords
              mercari_crawl_setting_required_keywords
            ]
          },
          janpara_crawl_setting: {
            include: %i[
              janpara_crawl_setting_exclude_keywords
              janpara_crawl_setting_required_keywords
            ]
          },
          iosys_crawl_setting: {
            include: %i[
              iosys_crawl_setting_exclude_keywords
              iosys_crawl_setting_required_keywords
            ]
          },
          pc_koubou_crawl_setting: {
            include: %i[
              pc_koubou_crawl_setting_exclude_keywords
              pc_koubou_crawl_setting_required_keywords
            ]
          },
          used_sofmap_crawl_setting: {
            include: %i[
              used_sofmap_crawl_setting_exclude_keywords
              used_sofmap_crawl_setting_required_keywords
            ]
          },
          category: {}
        ]
      }.freeze

      PRELOAD_OPTIONS = {
        yahoo_auction_crawl_setting: %i[
          yahoo_auction_crawl_setting_exclude_keywords
          yahoo_auction_crawl_setting_required_keywords
        ],
        mercari_crawl_setting: %i[
          mercari_crawl_setting_exclude_keywords
          mercari_crawl_setting_required_keywords
        ],
        janpara_crawl_setting: %i[
          janpara_crawl_setting_exclude_keywords
          janpara_crawl_setting_required_keywords
        ],
        iosys_crawl_setting: %i[
          iosys_crawl_setting_exclude_keywords
          iosys_crawl_setting_required_keywords
        ],
        pc_koubou_crawl_setting: %i[
          pc_koubou_crawl_setting_exclude_keywords
          pc_koubou_crawl_setting_required_keywords
        ],
        used_sofmap_crawl_setting: %i[
          used_sofmap_crawl_setting_exclude_keywords
          used_sofmap_crawl_setting_required_keywords
        ],
        category: []
      }.freeze

      def initialize(products)
        @products = products.preload(PRELOAD_OPTIONS)
      end

      def as_json(_opts = {})
        {
          products: @products.as_json(JSON_OPTIONS)
        }
      end
    end
  end
end
