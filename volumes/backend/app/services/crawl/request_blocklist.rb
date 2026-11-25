module Crawl
  module RequestBlocklist
    # blocked_request? は全サイトのリストを OR で評価するので、動画・広告の配信元は全クローラーで止める
    COMMON_BLOCKED_LIST = %w[
      .css
      youtube.com
      googlevideo.com
      doubleclick.net
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

    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) " \
                 "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36".freeze

    module_function

    def blocked_request?(url)
      blocked_url?(COMMON_BLOCKED_LIST, url) \
        || blocked_url?(YAHOO_AUCTION_BLOCKED_LIST, url) \
        || blocked_url?(PAYPAY_FLEAMARKET_BLOCKED_LIST, url)
    end

    def blocked_url?(blocked_list, url)
      blocked_list.any? { |blocked_url| url.include?(blocked_url) }
    end
  end
end
