module Crawl
  module YahooFleamarket
    module SyncProduct
      class Crawler
        RETRY_COUNT = 3

        MINUTE = "分前に更新".freeze
        HOUR = "時間前に更新".freeze
        DATE = "日前に更新".freeze
        MONTH = "ヶ月前に更新".freeze
        TIME_UNITS = [MINUTE, HOUR, DATE, MONTH].freeze

        def self.call(...)
          new(...).call
        end

        def initialize(yahoo_fleamarket_product:)
          @yahoo_fleamarket_product = yahoo_fleamarket_product
        end

        def call
          Crawl::Client.execute do |page|
            Retryable.retryable(tries: RETRY_COUNT) do
              page.goto(url)
              load(page)
              deleted?(page) ? deleted_crawl_result : upsertable_crawl_result(page)
            end
          end
        end

        private

        attr_reader :yahoo_fleamarket_product

        def url
          "https://paypayfleamarket.yahoo.co.jp/item/#{yahoo_fleamarket_product.yahoo_fleamarket_id}"
        end

        def load(page)
          sleep(2)
          30.times do
            page.mouse.wheel(0, 200)
            sleep(0.005)
          end
        end

        # 個別クロール処理を実装中
        def deleted?(page)
          page.query_selector("span:has-text('この商品は存在しません')").present?
        end

        def deleted_crawl_result
          crawl_result = CrawlResult.new(
            yahoo_fleamarket_id: yahoo_fleamarket_product.yahoo_fleamarket_id,
            seller_id: yahoo_fleamarket_product.seller_id,
            name: yahoo_fleamarket_product.name,
            price: yahoo_fleamarket_product.price,
            thumbnail_url: yahoo_fleamarket_product.thumbnail_url,
            published: yahoo_fleamarket_product.published,
            bought_date: yahoo_fleamarket_product.bought_date,
            deleted: true
          )

          handle_errors(crawl_result)
          crawl_result
        end

        def upsertable_crawl_result(page)
          crawl_result = CrawlResult.new(
            yahoo_fleamarket_id: yahoo_fleamarket_product.yahoo_fleamarket_id,
            seller_id: seller_id(page),
            name: name(page),
            price: price(page),
            thumbnail_url: thumbnail_url(page),
            published: published(page),
            bought_date: bought_date(page),
            deleted: false
          )

          handle_errors(crawl_result)
          crawl_result
        end

        def handle_errors(crawl_result)
          raise StandardError, crawl_result.errors.full_messages.join(", ") unless crawl_result.valid?
        end

        def seller_id(page)
          href = page.query_selector("a[href*='/user/']").get_attribute("href")
          href[%r{user/([^/]+)}, 1]
        end

        def name(page)
          page.query_selector(".ItemTitle__Component").inner_text
        end

        def price(page)
          page.query_selector(".ItemPrice__Component").inner_text.gsub(/,|円/, "").to_i
        end

        def thumbnail_url(page)
          page.query_selector(".ItemMain__Component img").get_attribute("src")
        end

        def published(page)
          page.query_selector("img[alt='sold']").blank?
        end

        def bought_date(page)
          date_str = page.query_selector('xpath=//*[img[@alt="時計アイコン"] and span]')&.inner_text
          return yahoo_fleamarket_product.bought_date if date_str.nil?

          parse_bought_date(date_str)
        end

        def parse_bought_date(date_str)
          case date_str
          when /#{MINUTE}|#{HOUR}/
            Time.current.beginning_of_day
          when /#{DATE}/
            Time.current.days_ago(date_str.gsub(DATE, "").to_i).beginning_of_day
          when /#{MONTH}/
            Time.current.months_ago(date_str.gsub(MONTH, "").to_i).beginning_of_day
          when /#{OTHER}/
            Time.current.months_ago(6).beginning_of_day
          end
        end
      end
    end
  end
end
