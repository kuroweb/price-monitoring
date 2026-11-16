module ProductMonitoring
  module Crawling
    module Mercari
      module Listing
        class Crawler
          MAX_PAGES = 5
          MAX_RESULTS_PER_PAGE = 100
          TIMEOUT_SECONDS = 60
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024

          def self.call(...)
            new(...).call
          end

          def initialize(product_crawl_setting:)
            @product_crawl_setting = product_crawl_setting
            @listings = {}
            @truncated = false
          end

          # 設定の検索結果URLのうちメルカリの分を、ページを送りながら取得する。全URLが失敗したらジョブを失敗にして再試行する。
          # 一覧から消えた出品を詳細で確かめるため、全URLを最後のページまで取得できたかも返す
          def call
            succeeded = UrlRouter.call(product_crawl_setting:).fetch(Mercari, []).map { |url| crawl(url) }
            raise "All search URLs failed" if succeeded.present? && succeeded.none?

            { listings: listings.values, complete: succeeded.present? && succeeded.all? && !truncated }
          end

          private

          attr_reader :product_crawl_setting, :listings, :truncated

          def crawl(url)
            fetch_pages(URI.parse(url)).each { |result| listings[result[:external_id]] ||= result }
            true
          rescue StandardError => e
            Rails.logger.warn("Crawl failed for #{url.split('?', 2).first}: #{e.class}: #{e.message}")
            false
          end

          # 途中で失敗したURLの出品は使わないので、URLのページをすべて取得してから返す
          def fetch_pages(uri)
            results = []
            Timeout.timeout(TIMEOUT_SECONDS) do
              MAX_PAGES.times do
                page = Nokogiri::HTML(fetch_page(uri))
                results.concat(checked_results(page))
                uri = next_url(uri, page)
                return results if uri.nil?
              end
              @truncated = true
            end
            results
          end

          # JavaScript で描画するので、描画を待ってスクロールしてから HTML を取り出す
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

          def checked_results(page)
            results = page.css("li[data-testid='item-cell']").first(MAX_RESULTS_PER_PAGE).filter_map do |dom|
              id = listing_id(dom)
              listing(dom, id) if id
            end
            empty_state = page.at_css(".merEmptyState")
            raise "Search page has no extractable listings" if results.empty? && empty_state&.text.blank?

            results
          end

          def listing_id(dom)
            href = dom.at_css("a")&.[]("href")
            href&.match(%r{/item/([^/?]+)})&.[](1)
          end

          def listing(dom, id)
            name = dom.at_css("[data-testid='thumbnail-item-name']")&.text.to_s.strip
            raise "Listing name is missing" if name.empty?

            # 既存のメルカリクローラーと同じく、画像URLは external_id から組み立てる
            { platform: SearchUrl::PLATFORM, external_id: id, name: name,
              price: price(dom.at_css("[data-testid='item-tile-price']")&.text),
              product_url: "https://#{SearchUrl::HOST}/item/#{id}",
              thumbnail_url: "https://static.mercdn.net/thumb/item/webp/#{id}_1.jpg",
              sold: dom.at_css("img[alt$='売り切れ']").present? }
          end

          # 「¥1,200」などの表示価格を整数にする。DBの整数の上限を超える値は価格なしとする
          def price(text)
            match = text.to_s.strip.match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
            value = match && match[1].delete(",").to_i
            value if value && value <= ProductCrawlResult::MAX_PRICE
          end

          def next_url(uri, page)
            return unless page.at_css("[data-testid='pagination-next-button']")

            query = URI.decode_www_form(uri.query)
            current = query.to_h.fetch("page_token", "v1:0").delete_prefix("v1:").to_i
            query.reject! { |key, _| key == "page_token" }
            query << ["page_token", "v1:#{current + 1}"]
            uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query) }
          end

          # リダイレクトで別のホストへ移っていないことを確かめる
          def validate_url(page)
            uri = URI.parse(page.url)
            valid = uri.scheme == "https" && uri.host == SearchUrl::HOST && uri.port == 443
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
