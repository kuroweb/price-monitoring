require "timeout"

module ProductMonitoring
  class Crawler
    TIMEOUT_SECONDS = 20
    TOTAL_TIMEOUT_SECONDS = 45
    MAX_RESULTS_PER_URL = 100

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
      params[:search_urls].each { |url| crawl_url(url) }
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
      remaining = deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
      raise Timeout::Error if remaining <= 0

      records = Timeout.timeout([remaining, TIMEOUT_SECONDS].min) { self.class.fetch(target) }
      records.each { |record| by_key[record[:external_id]] ||= record.merge(platform: target[:platform]) }
      sources << self.class.source(url, target[:platform], "succeeded", records.size)
    rescue StandardError => e
      Rails.logger.warn("Crawl failed for #{url.split('?', 2).first}: #{e.class}: #{e.message}")
      sources << self.class.source(url, target[:platform], "failed", 0)
    end

    private :params, :sources, :by_key, :deadline, :crawl_url, :crawl_target

    def self.fetch(target)
      target[:site].fetch(URI.parse(target[:canonical_url]))
    end

    def self.listing_nodes(page, selector)
      page.css(selector).first(MAX_RESULTS_PER_URL)
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
