module Crawl
  module Mercari
    class SyncBoughtDate
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
        return if mercari_product.published || mercari_product.bought_date.present?

        bought_date = fetch_bought_date

        if bought_date
          mercari_product.update(bought_date:)
        else
          mercari_product.destroy
        end
      end

      attr_reader :mercari_product

      def fetch_bought_date
        Crawl::Client.execute do |browser|
          Retryable.retryable(tries: RETRY_COUNT) do
            page = browser.new_page
            page.goto("https://jp.mercari.com/item/#{mercari_product.mercari_id}")

            sleep(2)
            deleted?(page) ? nil : parse_bought_date(bought_date(page))
          end
        end
      end

      def deleted?(page)
        page.query_selector(".merEmptyState").present?
      end

      def bought_date(page)
        page.query_selector("[data-testid='item-detail-container']")
            .query_selector_all("[class*='merText'][class*='body'][class*='secondary']")
            .find { |dom| TIME_UNITS.any? { |i| dom.inner_text&.include?(i) } }
            .inner_text
      end

      def parse_bought_date(date_str) # rubocop:disable Metrics/AbcSize
        if date_str.include?(MINUTE) || date_str.include?(HOUR)
          Time.current.beginning_of_day
        elsif date_str.include?(DATE)
          Time.current.days_ago(date_str.gsub(DATE, "").to_i).beginning_of_day
        elsif date_str.include?(MONTH)
          Time.current.months_ago(date_str.gsub(MONTH, "").to_i).beginning_of_day
        elsif date_str.include?(OTHER)
          Time.current.months_ago(6).beginning_of_day
        end
      end
    end
  end
end
