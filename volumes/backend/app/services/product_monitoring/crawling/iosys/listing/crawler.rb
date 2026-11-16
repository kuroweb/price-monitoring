module ProductMonitoring
  module Crawling
    module Iosys
      module Listing
        class Crawler
          class NonSuccessResponse < StandardError; end

          MAX_PAGES = 5
          # 実際の1ページの件数（イオシスは24件）より大きくする。超えた分は取得しないので、一覧を最後まで取得できなかったとする
          MAX_RESULTS_PER_PAGE = 200
          TIMEOUT_SECONDS = 180
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          # プロキシの約3割が 403 を返す
          FETCH_TRIES = 5

          def self.call(...)
            new(...).call
          end

          def initialize(product_crawl_setting:)
            @product_crawl_setting = product_crawl_setting
            @listings = {}
            @truncated = false
          end

          # 設定の検索結果URLのうちイオシスの分を、ページを送りながら取得する。全URLが失敗したらジョブを失敗にして再試行する。
          # 一覧から消えた出品を売り切れにするため、全URLを最後のページまで取得できたかも返す
          def call
            succeeded = UrlRouter.call(product_crawl_setting:).fetch(Iosys, []).map { |url| crawl(url) }
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

          # JavaScript なしで描画されるので、スクリプトを止めて取得する。
          # サイトに拒否されるプロキシがあるので、非 2xx なら接続し直して別のプロキシで試す
          def fetch_page(uri)
            Retryable.retryable(tries: FETCH_TRIES, on: NonSuccessResponse) do
              Client.execute(block_scripts: true) do |page|
                response = page.goto(uri.to_s)
                raise NonSuccessResponse, "Non-success HTTP response" unless response&.status&.between?(200, 299)

                checked_content(page)
              end
            end
          end

          def checked_results(page)
            results = page_results(page)
            raise "Search page has no extractable listings" if results.empty? && page.at_css("#empty")&.text.blank?

            results
          end

          def page_results(page)
            items = page.css("li.item")
            @truncated = true if items.size > MAX_RESULTS_PER_PAGE
            items.first(MAX_RESULTS_PER_PAGE).filter_map do |dom|
              id = listing_id(dom)
              listing(dom, id) if id
            end
          end

          def listing_id(dom)
            href = dom.at_css("a")&.[]("href")
            href&.match(%r{/items/([^?#]+)})&.[](1)
          end

          def listing(dom, id)
            name = dom.at_css(".name")&.text.to_s.strip
            raise "Listing name is missing" if name.empty?

            { platform: SearchUrl::PLATFORM, external_id: id, name: name, price: price(dom.at_css(".price")&.text),
              product_url: "https://#{SearchUrl::HOST}/items/#{id}", thumbnail_url: thumbnail_url(dom), sold: false }
          end

          def thumbnail_url(dom)
            image = dom.at_css("img")
            image_url = image&.[]("data-src").presence || image&.[]("src")
            image_url.present? ? URI.join("https://#{SearchUrl::HOST}", image_url).to_s : nil
          end

          # 「20,800円 (税込)」などの表示価格を整数にする。DBの整数の上限を超える値は価格なしとする
          def price(text)
            match = text.to_s.strip.match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
            value = match && match[1].delete(",").to_i
            value if value && value <= ProductCrawlResult::MAX_PRICE
          end

          def next_url(uri, page)
            return unless page.at_css(".page-link[rel='next']")

            query = URI.decode_www_form(uri.query)
            number = query.to_h.fetch("page", "1").to_i
            query.reject! { |name, _| name == "page" }
            query << ["page", [number + 1, 2].max.to_s]
            uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query) }
          end

          # リダイレクトで別のホストへ移っていないことと、HTML の大きさを確かめる
          def checked_content(page)
            uri = URI.parse(page.url)
            valid = uri.scheme == "https" && uri.host == SearchUrl::HOST && uri.port == 443
            raise "Unexpected page URL" unless valid && uri.userinfo.nil?

            html = page.content
            raise "Response exceeds size limit" if html.bytesize > MAX_RESPONSE_BYTES

            html
          end
        end
      end
    end
  end
end
