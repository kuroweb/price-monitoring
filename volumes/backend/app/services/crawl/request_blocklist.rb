module Crawl
  module RequestBlocklist
    # blocked_request? は全サイトのリストを OR で評価するので、動画・広告の配信元は全クローラーで止める
    COMMON_BLOCKED_LIST = %w[
      .css
      youtube.com
      googlevideo.com
      doubleclick.net
    ].freeze

    MERCARI_BLOCKED_LIST = %w[
      api.mercari.jp/client_events
      api.mercari.jp/services/master/v1/shippingMethods
      api.mercari.jp/services/notification/v1/get_unread_count
      api.mercari.jp/experiments/get_running_experiments_by_name
      api.mercari.jp/services/master/v1/itemColors
      api.mercari.jp/services/master/v1/itemSizes
      api.mercari.jp/services/master/v1/itemConditions
      api.mercari.jp/services/master/v1/shippingPayers
      api.mercari.jp/services/master/v1/reactions
      api.mercari.jp/master/v2/datasets/item_brands_for_content_page
      api.mercari.jp/master/v2/datasets/item_brands
      api.mercari.jp/services/item_watch/v1/ValidateText
      api.mercari.jp/v2/tag:suggest
      api.mercari.jp/services/seolp/v2/seoPages:search
      common.json
      mypage.json
      seo.json
      search.json
      validation.json
      sell.json
      brand.json
      user.json
      www.google.com
      googletagmanager.com
      securepubads.g.doubleclick.net
      sentry.io
      forter.com
      analytics.tiktok.com
      criteo.com
      criteo.net
      bat.bing.com
      eagle-insight.com
      jp.mercari.com/gtm/
      d1qmrxg9gbf226.cloudfront.net
    ].freeze

    YAHOO_AUCTION_BLOCKED_LIST = %w[
      yads.c.yimg.jp
      yads.yjtag.yahoo.co.jp
      www.googleadservices.com
      static.criteo.net
      clb.yahoo.co.jp
      mhd.yahoo.co.jp
      s.yimg.jp
      yjtag.yahoo.co.jp
      s.yjtag.jp
      facebook.net
    ].freeze

    PAYPAY_FLEAMARKET_BLOCKED_LIST = %w[
      paypayfleamarket.c.yimg.jp
      dsb.yahoo.co.jp
    ].freeze

    USED_SOFMAP_BLOCKED_LIST = %w[
      used.sofmap.com/r/js/swiper.min.js
      used.sofmap.com/r/js/dist/babel-polyfill.js
      used.sofmap.com/r/js/common.js
      used.sofmap.com/r/js/header_switcher.js
      used.sofmap.com/r/js/dist/mnd.min.js
      used.sofmap.com/r/js/dist/anchor_link.js
      used.sofmap.com/r/js/suggest.js
      used.sofmap.com/apis/sale-info-multi.aspx
      www.promisejs.org
      cdnjs.cloudflare.com
    ].freeze

    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) " \
                 "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36".freeze

    module_function

    def blocked_request?(url)
      blocked_url?(COMMON_BLOCKED_LIST, url) \
        || blocked_url?(MERCARI_BLOCKED_LIST, url) \
        || blocked_url?(YAHOO_AUCTION_BLOCKED_LIST, url) \
        || blocked_url?(PAYPAY_FLEAMARKET_BLOCKED_LIST, url) \
        || blocked_url?(USED_SOFMAP_BLOCKED_LIST, url)
    end

    def blocked_url?(blocked_list, url)
      blocked_list.any? { |blocked_url| url.include?(blocked_url) }
    end
  end
end
