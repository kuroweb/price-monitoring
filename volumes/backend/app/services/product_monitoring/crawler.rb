require "timeout"

module ProductMonitoring
  class Crawler
    TIMEOUT_SECONDS = 60
    TOTAL_TIMEOUT_SECONDS = 300
    MAX_RESULTS_PER_PAGE = 100
    MAX_PAGES_PER_URL = 5

    def self.call(...)
      new(...).call
    end

    def initialize(params:)
      @params = Input.call(params: params)
      @sources = []
      @by_key = {}
      @deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + TOTAL_TIMEOUT_SECONDS
    end

    def call
      generated = params[:platforms].flat_map do |platform|
        UrlRouter::SITES.find { |site| site::PLATFORM == platform }.search_urls(params[:keyword])
      end
      (generated + params[:search_urls]).each { |url| crawl_url(url) }
      results = by_key.values.map { |item| self.class.apply_filters(item, params) }
      { sources: sources, results: results, fetched_count: results.size,
        accepted_count: results.count { |result| result[:accepted] } }
    end

    attr_reader :params, :sources, :by_key, :deadline

    def crawl_url(url)
      target = UrlRouter.call(url: url)
      crawl_target(url, target)
    rescue ArgumentError
      sources << self.class.source(url, nil, "unsupported", 0)
    end

    def crawl_target(url, target)
      records = fetch_with_deadline(target)
      store_records(records, target[:platform])
      sources << self.class.source(url, target[:platform], "succeeded", records.size)
    rescue StandardError => e
      record_failure(url, target, e)
    end

    def fetch_with_deadline(target)
      remaining = deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
      raise Timeout::Error if remaining <= 0

      Timeout.timeout([remaining, TIMEOUT_SECONDS].min) { self.class.fetch(target) }
    end

    def record_failure(url, target, error)
      safe_url = target[:platform] == "yahoo_fleamarket" ? "https://#{Sites::YahooFleamarket::HOST}/search/[FILTERED]" : url.split("?", 2).first
      Rails.logger.warn("Crawl failed for #{safe_url}: #{error.class}: #{error.message}")
      sources << self.class.source(url, target[:platform], "failed", 0)
    end

    def store_records(records, platform)
      records.each { |record| by_key[record[:external_id]] ||= record.merge(platform: platform) }
    end

    private :params, :sources, :by_key, :deadline, :crawl_url, :crawl_target, :store_records, :fetch_with_deadline,
            :record_failure

    def self.fetch(target)
      uri = URI.parse(target[:canonical_url])
      records = []
      MAX_PAGES_PER_URL.times do
        page_records, next_uri = target[:site].fetch(uri)
        records.concat(page_records.first(MAX_RESULTS_PER_PAGE))
        # 売り切れだけのページなど、空のページの先にも出品があり得るので次ページの有無だけで止める
        break if next_uri.nil?

        uri = next_uri
      end
      records
    end

    def self.listing_nodes(page, selector)
      page.css(selector).first(MAX_RESULTS_PER_PAGE)
    end

    def self.parse_price(value)
      match = value.to_s.strip.match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
      price = match && match[1].delete(",").to_i
      price if price && price <= Input::MAX_PRICE
    end

    def self.apply_filters(item, params)
      reasons = Filter.call(item:, params:)
      item.merge(accepted: reasons.empty?, reasons: reasons)
    end

    def self.source(url, platform, status, count)
      { url: url, platform: platform, status: status,
        error: if status == "failed"
                 "Crawl failed"
               else
                 (status == "unsupported" ? "Unsupported URL" : nil)
               end, fetched_count: count }
    end
  end
end
