module ProductMonitoring
  module Crawling
    module Mercari
      module DetailPage
        class Crawler
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          DELETED_TEXTS = ["ページが見つかりませんでした", "該当する商品は削除されています。"].freeze

          def self.call(...)
            new(...).call
          end

          def initialize(external_id:)
            @external_id = external_id
          end

          # 個別ページから販売状態と売れた日を返す
          def call
            raise ArgumentError, "Invalid external ID" unless external_id.match?(/\A[a-zA-Z0-9_-]+\z/)

            page = Nokogiri::HTML(fetch_page(URI("https://#{ListPage::SearchUrl::HOST}/item/#{external_id}")))
            sold = sold_state(page)
            page.css("script, style").remove
            return { deleted: true } if deleted?(page)
            return {} if sold.nil? || !item_page?(page)

            { sold: sold, sold_at: sold ? sold_at(page) : nil }
          end

          private

          def item_page?(page)
            page.at_css("[data-testid='item-detail-container']") && page.at_css("[data-testid='price']")
          end

          attr_reader :external_id

          def deleted?(page)
            return false if page.at_css("[data-testid='item-detail-container']")

            page.at_css(".merEmptyState") || DELETED_TEXTS.any? { |text| page.text.include?(text) }
          end

          def sold_state(page)
            states = { "https://schema.org/SoldOut" => true, "https://schema.org/InStock" => false }
            page.css("script[type='application/ld+json']").each do |script|
              json_ld_products(script).each do |product|
                next unless product.is_a?(Hash) && product["@type"] == "Product"

                availability = product["offers"].is_a?(Hash) && product["offers"]["availability"]
                result = states[availability]
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

          def sold_at(page)
            text = page.at_css("[data-testid='item-detail-container'] div[aligncontent='start']:has(svg)")&.text&.strip
            return unless text && text.length < 20

            parse_date(text)
          end

          def parse_date(text)
            case text
            when /\A\d+(?:分前|時間前)\z/ then Time.current.beginning_of_day
            when /\A(\d+)日前\z/ then Time.current.days_ago(Regexp.last_match(1).to_i).beginning_of_day
            when /\A(\d+)か月前\z/ then Time.current.months_ago(Regexp.last_match(1).to_i).beginning_of_day
            when "半年以上前" then Time.current.months_ago(6).beginning_of_day
            end
          end

          def fetch_page(uri)
            Client.execute do |page|
              response = page.goto(uri.to_s)
              raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

              validate_url(page)
              Kernel.sleep(2)
              30.times do
                page.mouse.wheel(0, 200)
                Kernel.sleep(0.005)
              end
              checked_content(page)
            end
          end

          # リダイレクトで別のホストへ移っていないことを確かめる
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
