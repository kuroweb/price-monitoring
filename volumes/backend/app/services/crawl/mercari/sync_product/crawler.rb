module Crawl
  module Mercari
    module SyncProduct
      class Crawler
        RETRY_COUNT = 3

        MINUTE = "分前".freeze
        HOUR = "時間前".freeze
        DATE = "日前".freeze
        MONTH = "か月前".freeze
        OTHER = "半年以上前".freeze
        TIME_UNITS = [MINUTE, HOUR, DATE, MONTH, OTHER].freeze

        def self.call(...)
          new(...).call
        end

        def initialize(mercari_product:)
          @mercari_product = mercari_product
        end

        def call
          Crawl::Client.execute do |page|
            Retryable.retryable(tries: RETRY_COUNT) do
              page.goto(url)
              load(page)
              deleted?(page) ? deleted_crawl_result : exist_crawl_result(page)
            end
          end
        end

        private

        attr_reader :mercari_product

        def url
          "https://jp.mercari.com/item/#{mercari_product.mercari_id}"
        end

        def load(page)
          sleep(2)
          30.times do
            page.mouse.wheel(0, 200)
            sleep(0.005)
          end
        end

        def deleted?(page)
          page.query_selector(".merEmptyState").present?
        end

        def deleted_crawl_result
          crawl_result = CrawlResult.new(
            mercari_id: mercari_product.mercari_id,
            name: mercari_product.name,
            price: mercari_product.price,
            thumbnail_url: mercari_product.thumbnail_url,
            published: mercari_product.published,
            bought_date: mercari_product.bought_date,
            deleted: true
          )

          handle_errors(crawl_result)
          crawl_result
        end

        def exist_crawl_result(page)
          crawl_result = CrawlResult.new(
            mercari_id: mercari_product.mercari_id,
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

        def name(page)
          page.query_selector("[class*='heading'][class*='page']").inner_text
        end

        def price(page)
          page.query_selector("[data-testid='price']").inner_text.gsub(/¥|,/, "")
        end

        def thumbnail_url(page)
          page.query_selector("img").get_attribute("src")
        end

        def published(page)
          page.query_selector("text='※売り切れのためコメントできません'").nil?
        end

        def bought_date(page)
          date_str = page.query_selector("[data-testid='item-detail-container']")
                         .query_selector_all("[class*='merText'][class*='body'][class*='secondary']")
                         .find { |dom| TIME_UNITS.any? { |i| dom.inner_text&.include?(i) } }
                         .inner_text
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
