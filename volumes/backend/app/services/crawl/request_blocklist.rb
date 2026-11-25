module Crawl
  module RequestBlocklist
    # blocked_request? は全サイトのリストを OR で評価するので、動画・広告の配信元は全クローラーで止める
    COMMON_BLOCKED_LIST = %w[
      .css
      youtube.com
      googlevideo.com
      doubleclick.net
      www.google.com
      googletagmanager.com
      sentry.io
      forter.com
      analytics.tiktok.com
      criteo.com
      criteo.net
      bat.bing.com
      eagle-insight.com
    ].freeze

    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) " \
                 "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36".freeze

    module_function

    def blocked_request?(url)
      blocked_url?(COMMON_BLOCKED_LIST, url)
    end

    def blocked_url?(blocked_list, url)
      blocked_list.any? { |blocked_url| url.include?(blocked_url) }
    end
  end
end
