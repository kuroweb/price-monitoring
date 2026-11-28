module ProductMonitoring
  module Crawling
    module Mercari
      module DetailPage
        class Crawler
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          DELETED_TEXTS = ["ページが見つかりませんでした", "該当する商品は削除されています。"].freeze
          NOT_FOUND_TEXTS = ["ページが見つかりませんでした",
                             "お探しのページはURLが間違っているか、削除された可能性があります。"].freeze

          def self.call(...)
            new(...).call
          end

          def initialize(external_id:)
            @external_id = external_id
          end

          def call
            raise ArgumentError, "Invalid external ID" unless external_id.match?(/\A[a-zA-Z0-9_-]+\z/)

            html, status = fetch_page
            page = Nokogiri::HTML(html)
            return not_found_result(page) if status == 404

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

          def not_found_result(page)
            page.css("script, style").remove
            body = page.at_css("body")&.text.to_s
            found = !page.at_css("[data-testid='item-detail-container']") &&
                    NOT_FOUND_TEXTS.all? { |text| body.include?(text) }
            raise "Non-success HTTP response" unless found

            { deleted: true }
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

          def fetch_page
            url = "https://#{ListPage::SearchUrl::HOST}/item/#{external_id}"
            Client.execute do |page|
              status = page.goto(url)&.status
              raise "Non-success HTTP response" unless status == 404 || status&.between?(200, 299)

              validate_url(page)
              next [checked_not_found_content(page, url), status] if status == 404

              Kernel.sleep(2)
              30.times do
                page.mouse.wheel(0, 200)
                Kernel.sleep(0.005)
              end
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
