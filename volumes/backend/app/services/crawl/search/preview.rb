require "ipaddr"
require "socket"
require "net/http"
require "timeout"
require "nokogiri"

module Crawl::Search
  class Preview
    TIMEOUT_SECONDS = 20
    TOTAL_TIMEOUT_SECONDS = 45
    MAX_RESPONSE_BYTES = 3 * 1024 * 1024
    MAX_RESULTS_PER_URL = 100
    NON_PUBLIC_V4 = %w[0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.0.0.0/24
                       192.0.2.0/24 192.168.0.0/16 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24 224.0.0.0/4 240.0.0.0/4].map do |range|
      IPAddr.new(range)
    end.freeze

    def self.call(params:)
      params = Input.call(params: params)
      urls = params[:search_urls]
      sources = []
      by_key = {}
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + TOTAL_TIMEOUT_SECONDS
      urls.each do |url|
        begin
          target = UrlRouter.call(url: url)
        rescue ArgumentError
          sources << source(url, nil, "unsupported", 0)
          next
        end
        begin
          remaining = deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
          raise Timeout::Error if remaining <= 0

          records = Timeout.timeout([remaining, TIMEOUT_SECONDS].min) { fetch(target) }
          records.each { |record| by_key[record[:external_id]] ||= record.merge(platform: target[:platform]) }
          sources << source(url, target[:platform], "succeeded", records.size)
        rescue StandardError
          sources << source(url, target[:platform], "failed", 0)
        end
      end
      results = by_key.values.map { |item| apply_filters(item, params) }
      { sources: sources, results: results, fetched_count: results.size, accepted_count: results.count do |r|
        r[:accepted]
      end }
    end

    def self.fetch(target)
      uri = URI.parse(target[:canonical_url])
      response = fetch_pinned(uri)
      page = Nokogiri::HTML(response.body)
      results = target[:platform] == "mercari" ? mercari_results(page) : iosys_results(page)
      if results.empty?
        empty = page.at_css(target[:platform] == "mercari" ? ".merEmptyState" : "#empty")
        raise "Search page has no extractable listings" unless empty && !empty.text.strip.empty?
      end
      results
    end

    def self.fetch_pinned(uri)
      addresses = Socket.getaddrinfo(uri.host, 443, nil, :STREAM).map { |entry| entry[3] }.uniq
      raise "No public address" if addresses.empty? || addresses.any? { |address| !public_address?(address) }

      http = Net::HTTP.new(uri.host, 443, nil)
      http.ipaddr = addresses.first
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.open_timeout = 5
      http.read_timeout = 15
      http.write_timeout = 5 if http.respond_to?(:write_timeout=)
      request = Net::HTTP::Get.new(uri.request_uri, { "User-Agent" => Crawl::RequestBlocklist::USER_AGENT })
      body = +""
      response = http.start do |connection|
        connection.request(request) do |incoming|
          raise "Redirects and non-success HTTP responses are rejected" unless incoming.is_a?(Net::HTTPSuccess)

          incoming.read_body do |chunk|
            raise "Response exceeds size limit" if body.bytesize + chunk.bytesize > MAX_RESPONSE_BYTES

            body << chunk
          end
        end
      end
      raise "Redirects and non-success HTTP responses are rejected" unless response.is_a?(Net::HTTPSuccess)

      response.body = body
      response
    end

    def self.public_address?(address)
      ip = IPAddr.new(address)
      return NON_PUBLIC_V4.none? { |range| range.include?(ip) } if ip.ipv4?

      IPAddr.new("2000::/3").include?(ip) && !IPAddr.new("2001:db8::/32").include?(ip)
    rescue IPAddr::InvalidAddressError
      false
    end

    def self.mercari_results(page)
      listing_nodes(page, "li[data-testid='item-cell']").filter_map do |dom|
        href = dom.at_css("a")&.[]("href")
        id = href&.match(%r{/item/([^/?]+)})&.[](1)
        next unless id

        name = dom.at_css("[data-testid='thumbnail-item-name']")&.text.to_s.strip
        raise "Listing name is missing" if name.empty?

        price = parse_price(dom.at_css("[data-testid='item-tile-price']")&.text)
        { external_id: id, name: name, price: price, product_url: "https://jp.mercari.com/item/#{id}" }
      end
    end

    def self.iosys_results(page)
      listing_nodes(page, "li.item").filter_map do |dom|
        id = dom.at_css("a")&.[]("href")&.match(%r{/items/([^?#]+)})&.[](1)
        next unless id

        name = dom.at_css(".name")&.text.to_s.strip
        raise "Listing name is missing" if name.empty?

        { external_id: id, name: name, price: parse_price(dom.at_css(".price")&.text), product_url: "https://iosys.co.jp/items/#{id}" }
      end
    end

    def self.listing_nodes(page, selector)
      page.css(selector).first(MAX_RESULTS_PER_URL)
    end

    def self.parse_price(value)
      digits = value.to_s.gsub(/[^0-9]/, "")
      digits.empty? ? nil : digits.to_i
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
