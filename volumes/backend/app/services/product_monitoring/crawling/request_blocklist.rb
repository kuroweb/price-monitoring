module ProductMonitoring
  module Crawling
    # 取得に要らない広告・計測・動画などへのリクエストを止め、プロキシの通信量と待ち時間を減らす
    module RequestBlocklist
      URLS = %w[
        .css
        youtube.com
        googlevideo.com
        doubleclick.net
        www.google.com
        googletagmanager.com
        www.google-analytics.com
        www.googleadservices.com
        apis.google.com
        pagead2.googlesyndication.com
        facebook.net
        sentry.io
        forter.com
        analytics.tiktok.com
        criteo.com
        criteo.net
        bat.bing.com
        eagle-insight.com
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
        jp.mercari.com/gtm/
        d1qmrxg9gbf226.cloudfront.net
        yads.c.yimg.jp
        yads.yjtag.yahoo.co.jp
        clb.yahoo.co.jp
        mhd.yahoo.co.jp
        s.yimg.jp
        yjtag.yahoo.co.jp
        s.yjtag.jp
        paypayfleamarket.c.yimg.jp
        dsb.yahoo.co.jp
        www.janpara.co.jp/javascripts
        www.janpara.co.jp/common
        www.janpara.co.jp/poplink
        m.geniee-search.net
        flux-cdn.com
        polyfill.io
        checkout-api.worldshopping.jp
        statics.a8.net
        code.jquery.com
        maxcdn.bootstrapcdn.com
        cdnjs.cloudflare.com
        www.promisejs.org
        platform.twitter.com
        cd.ladsp.com
        px.ladsp.com
        um.ladsp.com
        rtg-endpoint.global.ssl.fastly.net
      ].freeze

      def self.blocked?(url)
        URLS.any? { |blocked| url.include?(blocked) }
      end
    end
  end
end
