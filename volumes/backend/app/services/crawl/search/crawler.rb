require "net/http"
require "timeout"
require "nokogiri"

module Crawl
  module Search
    class Crawler
      TIMEOUT_SECONDS = 20
      TOTAL_TIMEOUT_SECONDS = 45
      MAX_RESPONSE_BYTES = 3 * 1024 * 1024
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
        uri = URI.parse(target[:canonical_url])
        html = target[:platform] == "mercari" ? fetch_mercari_page(uri) : fetch_page(uri).body
        page = Nokogiri::HTML(html)
        results = target[:platform] == "mercari" ? mercari_results(page) : iosys_results(page)
        if results.empty?
          empty = page.at_css(target[:platform] == "mercari" ? ".merEmptyState" : "#empty")
          raise "Search page has no extractable listings" unless empty && !empty.text.strip.empty?
        end
        results
      end

      def self.fetch_mercari_page(uri)
        Crawl::Client.execute do |page|
          response = page.goto(uri.to_s)
          raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

          sleep(2)
          30.times do
            page.mouse.wheel(0, 200)
            sleep(0.005)
          end
          page.content
        end
      end

      # 取得先は UrlRouter で許可したホストの検索ページに限る。リダイレクトは追わず、応答は読み取り中に打ち切る
      def self.fetch_page(uri)
        http = build_http(uri)
        request = Net::HTTP::Get.new(uri.request_uri, { "User-Agent" => Crawl::RequestBlocklist::USER_AGENT })
        body = +""
        response = http.start do |connection|
          connection.request(request) { |incoming| read_response(incoming, body) }
        end
        raise "Redirects and non-success HTTP responses are rejected" unless response.is_a?(Net::HTTPSuccess)

        response.body = body
        response
      end

      def self.build_http(uri)
        http = Net::HTTP.new(uri.host, 443, nil)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.open_timeout = 5
        http.read_timeout = 15
        http.write_timeout = 5 if http.respond_to?(:write_timeout=)
        http
      end

      def self.read_response(incoming, body)
        raise "Redirects and non-success HTTP responses are rejected" unless incoming.is_a?(Net::HTTPSuccess)

        incoming.read_body do |chunk|
          raise "Response exceeds size limit" if body.bytesize + chunk.bytesize > MAX_RESPONSE_BYTES

          body << chunk
        end
      end

      def self.mercari_results(page)
        listing_nodes(page, "li[data-testid='item-cell']").filter_map do |dom|
          href = dom.at_css("a")&.[]("href")
          id = href&.match(%r{/item/([^/?]+)})&.[](1)
          next unless id

          name = dom.at_css("[data-testid='thumbnail-item-name']")&.text.to_s.strip
          raise "Listing name is missing" if name.empty?

          price = parse_price(dom.at_css("[data-testid='item-tile-price']")&.text)
          # 既存のメルカリクローラーと同じく、画像URLは external_id から組み立てる
          { external_id: id, name: name, price: price, product_url: "https://jp.mercari.com/item/#{id}",
            thumbnail_url: "https://static.mercdn.net/thumb/item/webp/#{id}_1.jpg" }
        end
      end

      def self.iosys_results(page)
        listing_nodes(page, "li.item").filter_map do |dom|
          id = dom.at_css("a")&.[]("href")&.match(%r{/items/([^?#]+)})&.[](1)
          next unless id

          name = dom.at_css(".name")&.text.to_s.strip
          raise "Listing name is missing" if name.empty?

          image = dom.at_css("img")
          image_url = image&.[]("data-src").presence || image&.[]("src")
          { external_id: id, name: name, price: parse_price(dom.at_css(".price")&.text), product_url: "https://iosys.co.jp/items/#{id}",
            thumbnail_url: image_url.present? ? URI.join("https://iosys.co.jp", image_url).to_s : nil }
        end
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
end
