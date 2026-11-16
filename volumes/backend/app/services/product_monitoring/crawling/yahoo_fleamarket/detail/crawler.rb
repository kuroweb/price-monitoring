module ProductMonitoring
  module Crawling
    module YahooFleamarket
      module Detail
        class Crawler
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          DATE_UNITS = { "日" => :days, "週間" => :weeks, "ヶ月" => :months }.freeze

          def self.call(...)
            new(...).call
          end

          def initialize(external_id:)
            @external_id = external_id
          end

          # 個別ページから販売状態と売れた日を返す
          def call
            raise ArgumentError, "Invalid external ID" unless external_id.match?(/\A[a-zA-Z0-9_-]+\z/)

            page = Nokogiri::HTML(fetch_page(URI("https://#{Listing::SearchUrl::HOST}/item/#{external_id}")))
            sold = sold_state(page)
            return {} if sold.nil?

            { sold: sold, bought_date: sold ? bought_date(page) : nil }
          end

          private

          attr_reader :external_id

          def sold_state(page)
            states = { "https://schema.org/OutOfStock" => true, "https://schema.org/InStock" => false }
            page.css('script[type="application/ld+json"]').each do |script|
              json_ld_products(script).each do |product|
                next unless product.is_a?(Hash) && product["@type"] == "Product" && product["offers"].is_a?(Hash)

                result = states[product["offers"]["availability"]]
                return result unless result.nil?
              end
            end
            nil
          end

          def json_ld_products(script)
            data = JSON.parse(script.text)
            data = data["@graph"] if data.is_a?(Hash) && data["@graph"].is_a?(Array)
            data.is_a?(Array) ? data : [data]
          rescue JSON::ParserError
            []
          end

          def bought_date(page)
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

          def fetch_page(uri)
            Client.execute(allow_script_host: "paypayfleamarket.c.yimg.jp") do |page|
              response = page.goto(uri.to_s)
              raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

              validate_url(page)
              Kernel.sleep(2)
              checked_content(page)
            end
          end

          # リダイレクトで別のホストへ移っていないことを確かめる
          def validate_url(page)
            uri = URI.parse(page.url)
            valid = uri.scheme == "https" && uri.host == Listing::SearchUrl::HOST && uri.port == 443
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
