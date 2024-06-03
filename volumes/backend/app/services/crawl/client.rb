module Crawl
  class Client # rubocop:disable Metrics/ClassLength
    COMMON_BLOCKED_LIST = %w[.css].freeze

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
      api.mercari.jp/master/v2/datasets/item_categories
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

    JANPARA_BLOCKED_LIST = %w[
      www.janpara.co.jp/javascripts
      www.janpara.co.jp/common
      www.janpara.co.jp/poplink
      apis.google.com
      m.geniee-search.net
      pagead2.googlesyndication.com
      flux-cdn.com
    ].freeze

    IOSYS_BLOCKED_LIST = %w[
      iosys.co.jp/fonts/vendor/font-awesome/fontawesome-webfont.woff2
      iosys.co.jp/js/nouislider.min.js
      iosys.co.jp/js/favorites/localforage.js
      iosys.co.jp/js/searches/nouislider.js
      iosys.co.jp/js/favorites/favorite.js
      iosys.co.jp/js/scripts.js
      iosys.co.jp/js/searches/pc-easy-search.js
      iosys.co.jp/js/favorites/sweetalert.min.js
      iosys.co.jp/js/swiper.ver6.min.js
      iosys.co.jp/js/histories/browsing-list.js
      iosys.co.jp/js/search.js
      iosys.co.jp/js/histories/browsing.js
      iosys.co.jp/js/jquery-numerator.js
      iosys.co.jp/js/searches/refine-search.js
      iosys.co.jp/js/searches/refine-tab.js
      iosys.co.jp/js/sliders/itemlist.js
      polyfill.io/v2/polyfill.min.js
      www.google-analytics.com
      checkout-api.worldshopping.jp
      statics.a8.net
      code.jquery.com
      maxcdn.bootstrapcdn.com
    ].freeze

    PC_KOUBOU_BLOCKED_LIST = %w[
      www.pc-koubou.jp/pwa.js
      www.pc-koubou.jp/user_data/root_alias/basestyle/js/cssrelpreload.js
      www.pc-koubou.jp/user_data/packages/default/_asset/js/setting.js
      www.pc-koubou.jp/user_data/packages/default/design/common/js/common_minify.js
      www.pc-koubou.jp/user_data/packages/responsive/_asset/js/search_refine.js
      www.pc-koubou.jp/user_data/packages/default/design/common/js/secom.js
      www.pc-koubou.jp/user_data/packages/responsive/_asset/js/chatbot.js
      www.pc-koubou.jp/user_data/root_alias/search/faq/js/faq.js
      www.pc-koubou.jp/user_data/floating.php
      www.pc-koubou.jp/api/getDate.php
      pc-koubou.my.salesforce.com
      pckoubou-f-s.snva.jp
      service.force.com
      cd.ladsp.com
      platform.twitter.com
      px.ladsp.com
      um.ladsp.com
      bvr.ast.snva.jp/beaver.js
      rtg-endpoint.global.ssl.fastly.net/page-event/script.js
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

    class << self
      def execute(&block)
        Playwright.connect_to_playwright_server(ENV.fetch("PLAYWRIGHT_URL")) do |playwright|
          playwright.chromium.launch(**launch_options) do |browser|
            browser.new_context(**context_options) do |context|
              page = context.new_page
              page.route("**/*", ->(route, request) { blocked_request?(request.url) ? route.abort : route.fallback })
              block.call(page)
            end
          end
        end
      end

      def launch_options
        {
          headless: true,
          args: ["--blink-settings=imagesEnabled=false", "--disable-remote-fonts"]
        }
      end

      def context_options
        # server, username, password = Proxy.get

        {
          userAgent: USER_AGENT,
          # proxy: { server:, username:, password: }
          proxy: {
            server: ENV.fetch("PROXY_HOST"),
            username: ENV.fetch("PROXY_USERNAME"),
            password: ENV.fetch("PROXY_PASSWORD")
          }
        }
      end

      def blocked_request?(url)
        blocked_url?(COMMON_BLOCKED_LIST, url) \
          || blocked_url?(MERCARI_BLOCKED_LIST, url) \
          || blocked_url?(YAHOO_AUCTION_BLOCKED_LIST, url) \
          || blocked_url?(JANPARA_BLOCKED_LIST, url) \
          || blocked_url?(IOSYS_BLOCKED_LIST, url) \
          || blocked_url?(PC_KOUBOU_BLOCKED_LIST, url) \
          || blocked_url?(USED_SOFMAP_BLOCKED_LIST, url)
      end

      def blocked_url?(blocked_list, url)
        blocked_list.any? { |blocked_url| url.include?(blocked_url) }
      end
    end
  end
end
