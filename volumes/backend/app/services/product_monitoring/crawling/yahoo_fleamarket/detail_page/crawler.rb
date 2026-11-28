module ProductMonitoring
  module Crawling
    module YahooFleamarket
      module DetailPage
        class Crawler
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          NOT_FOUND_TEXT = "この商品は存在しません".freeze
          DATE_UNITS = { "日" => :days, "週間" => :weeks, "ヶ月" => :months }.freeze

          def self.call(...)
            new(...).call
          end

          def initialize(external_id:)
            @external_id = external_id
          end

          def call
            raise ArgumentError, "Invalid external ID" unless external_id.match?(/\A[a-zA-Z0-9_-]+\z/)

            html, status = fetch_page("https://#{ListPage::SearchUrl::HOST}/item/#{external_id}")
            page = Nokogiri::HTML(html)
            return not_found_result(page) if status == 404

            sold = sold_state(page)
            return {} if sold.nil?

            { sold: sold, sold_at: sold ? sold_at(page) : nil }
          end

          private

          attr_reader :external_id

          def sold_state(page)
            states = { "https://schema.org/OutOfStock" => true, "https://schema.org/InStock" => false }
            products(page).each do |product|
              next unless product["offers"].is_a?(Hash)

              result = states[product["offers"]["availability"]]
              return result unless result.nil?
            end
            nil
          end

          def not_found_result(page)
            raise "Non-success HTTP response" if products(page).any?

            page.css("main > aside script, main > aside style").remove
            found = page.css("main > aside span").any? { |node| node.text.strip == NOT_FOUND_TEXT }
            raise "Non-success HTTP response" unless found

            { deleted: true }
          end

          def products(page)
            page.css('script[type="application/ld+json"]').flat_map { |script| json_ld_products(script) }
                .select { |product| product.is_a?(Hash) && product["@type"] == "Product" }
          end

          def json_ld_products(script)
            data = JSON.parse(script.text)
            data = data["@graph"] if data.is_a?(Hash) && data["@graph"].is_a?(Array)
            data.is_a?(Array) ? data : [data]
          rescue JSON::ParserError
            []
          end

          def sold_at(page)
            text = page.at_css('aside:has(> img[alt="時計アイコン"]) > span')&.text.to_s.strip
            parse_date(text)
          end

          def parse_date(text)
            case text
            when /\A\d+(?:分前|時間前)に更新\z/ then Time.current.beginning_of_day
            when /\A(\d+)(日|週間|ヶ月)前に更新\z/
              Regexp.last_match(1).to_i.public_send(DATE_UNITS[Regexp.last_match(2)]).ago.beginning_of_day
            when /\A半年前以上に更新\z/, /\A半年以上前に更新\z/ then Time.current.months_ago(6).beginning_of_day
            end
          end

          def fetch_page(url)
            Client.execute(allow_script_host: "paypayfleamarket.c.yimg.jp") do |page|
              status = page.goto(url)&.status
              raise "Non-success HTTP response" unless status == 404 || status&.between?(200, 299)

              validate_url(page)
              next [checked_not_found_content(page, url), status] if status == 404

              Kernel.sleep(2)
              [checked_content(page), status]
            end
          end

          def checked_not_found_content(page, url)
            raise "Unexpected page URL" unless page.url == url

            checked_content(page).tap { raise "Unexpected page URL" unless page.url == url }
          end

          def validate_url(page)
            uri = URI.parse(page.url)
            valid = uri.scheme == "https" && uri.host == ListPage::SearchUrl::HOST && uri.port == 443
            raise "Unexpected page URL" unless valid && uri.userinfo.nil?
          end

          def checked_content(page)
            validate_url(page)
            html = page.content
            raise "Response exceeds size limit" if html.bytesize > MAX_RESPONSE_BYTES

            html
          end
        end
      end
    end
  end
end
