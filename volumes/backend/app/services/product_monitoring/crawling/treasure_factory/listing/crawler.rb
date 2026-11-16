module ProductMonitoring
  module Crawling
    module TreasureFactory
      module Listing
        class Crawler
          class NonSuccessResponse < StandardError; end

          MAX_PAGES = 5
          MAX_RESULTS_PER_PAGE = 100
          TIMEOUT_SECONDS = 60
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          FETCH_TRIES = 5

          def self.call(...)
            new(...).call
          end

          def initialize(product_crawl_setting:)
            @product_crawl_setting = product_crawl_setting
            @listings = {}
          end

          # 設定の検索結果URLのうちトレファクの分を、ページを送りながら取得する。全URLが失敗したらジョブを失敗にして再試行する
          def call
            succeeded = UrlRouter.call(product_crawl_setting:).fetch(TreasureFactory, []).map { |url| crawl(url) }
            raise "All search URLs failed" if succeeded.present? && succeeded.none?

            listings.values
          end

          private

          attr_reader :product_crawl_setting, :listings

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

          # 売り切れの出品は一覧に価格がないので、販売中の出品だけを返す。
          # 売り切れだけのページは出品があっても結果が空になる
          def checked_results(page)
            results = page.css("li.pj-search_item").first(MAX_RESULTS_PER_PAGE).filter_map do |dom|
              id = listing_id(dom)
              listing(dom, id) if id && !dom.at_css(".cm-itemlist_soldout")
            end
            search_page = page.at_css("li.pj-search_item, .pj-search_not_found")
            raise "Search page has no extractable listings" if results.empty? && !search_page

            results
          end

          def listing_id(dom)
            href = dom.at_css("a.cm-itemlist_itemcode_link")&.[]("href")
            href&.match(%r{\A/item/(\d+)\z})&.[](1)
          end

          def listing(dom, id)
            image = dom.at_css(".cm-itemlist_image img")
            name = listing_name(dom, image)
            raise "Listing name is missing" if name.blank?

            { platform: SearchUrl::PLATFORM, external_id: id, name: name,
              price: price(dom.at_css(".cm-itemlist_price")&.text),
              product_url: "https://#{SearchUrl::HOST}/item/#{id}", thumbnail_url: thumbnail_url(image), sold: false }
          end

          # 画像の代替テキストはブランド名と型番を含み、個別ページの商品名と一致する
          def listing_name(dom, image)
            image&.[]("alt").to_s.strip.presence || dom.css(".cm-itemlist_text").map { |p| p.text.strip }.join(" ")
          end

          def thumbnail_url(image)
            image_url = image&.[]("data-src").presence || image&.[]("src")
            image_url.present? ? URI.join("https://#{SearchUrl::HOST}", image_url).to_s : nil
          end

          # 「¥1,200」などの表示価格を整数にする。DBの整数の上限を超える値は価格なしとする
          def price(text)
            match = text.to_s.strip.match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
            value = match && match[1].delete(",").to_i
            value if value && value <= ProductCrawlResult::MAX_PRICE
          end

          def next_url(uri, page)
            return unless page.at_css(".cm-pagination a[rel='next']")

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
