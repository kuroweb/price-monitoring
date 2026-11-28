module ProductMonitoring
  module Crawling
    module YahooFleamarket
      module ListPage
        class Crawler
          MAX_PAGES = 5
          # 実際の1ページの件数（Yahoo!フリマは100件）より大きくする。超えた分は取得しないので、一覧を最後まで取得できなかったとする
          MAX_RESULTS_PER_PAGE = 200
          TIMEOUT_SECONDS = 180
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024

          def self.call(...)
            new(...).call
          end

          def initialize(crawl_setting:)
            @crawl_setting = crawl_setting
            @listings = {}
            @truncated = false
          end

          # 設定の検索結果URLのうちYahoo!フリマの分を、ページを送りながら取得する。全URLが失敗したらジョブを失敗にして再試行する。
          # 一覧から消えた出品を詳細で確かめるため、全URLを最後のページまで取得できたかも返す
          def call
            succeeded = UrlRouter.call(crawl_setting:).fetch(YahooFleamarket, []).map { |url| crawl(url) }
            raise "All search URLs failed" if succeeded.present? && succeeded.none?

            { listings: listings.values, complete: succeeded.present? && succeeded.all? && !truncated }
          end

          private

          attr_reader :crawl_setting, :listings, :truncated

          def crawl(url)
            fetch_pages(URI.parse(url)).each { |result| listings[result[:external_id]] ||= result }
            true
          rescue StandardError => e
            # 検索ワードがパスに入るので、ログには検索ワードを伏せた URL を出す
            Rails.logger.warn("Crawl failed for https://#{SearchUrl::HOST}/search/[FILTERED]: #{e.class}: #{e.message}")
            false
          end

          # 途中で失敗したURLの出品は使わないので、URLのページをすべて取得してから返す
          def fetch_pages(uri)
            results = []
            Timeout.timeout(TIMEOUT_SECONDS) do
              MAX_PAGES.times do
                html = fetch_page(uri)
                return results if html.nil?

                page = Nokogiri::HTML(html)
                results.concat(checked_results(page))
                uri = next_url(uri, page)
                return results if uri.nil?
              end
              @truncated = true
            end
            results
          end

          # 該当する出品がない検索は 404 を返すので、空の検索結果と判定できれば nil を返す
          def fetch_page(uri)
            Client.execute(allow_script_host: "paypayfleamarket.c.yimg.jp") do |page|
              status = page.goto(uri.to_s)&.status
              raise "Non-success HTTP response" unless status&.between?(200, 299) || status == 404

              Kernel.sleep(2)
              html = checked_content(page)
              next html unless status == 404
              raise "Non-success HTTP response" unless empty_search?(html, uri)
            end
          end

          def empty_search?(html, uri)
            data = JSON.parse(Nokogiri::HTML(html).at_css('script#__NEXT_DATA__[type="application/json"]')&.text.to_s)
            search = data.dig("props", "initialState", "searchState", "search")
            keyword = URI::DEFAULT_PARSER.unescape(uri.path.delete_prefix("/search/"))
            search.dig("searchParams", "query") == keyword &&
              search.dig("result", "metadata", "retriedWithVectorSearch") == true
          rescue JSON::ParserError, TypeError, NoMethodError
            false
          end

          def checked_results(page)
            results = page.css('a[href^="/item/"]').filter_map { |link| listing(link) }
            raise "Search page has no extractable listings" if results.empty?

            @truncated = true if results.size > MAX_RESULTS_PER_PAGE
            sellers = SellerIds.call(page)
            results.first(MAX_RESULTS_PER_PAGE).map { |result| result.merge(seller_id: sellers[result[:external_id]]) }
          end

          def listing(link)
            id = link["href"]&.match(%r{\A/item/([a-zA-Z0-9_-]+)\z})&.[](1)
            image = link.at_css('img:not([alt="sold"])')
            price = link.css("p").filter_map { |p| price(p.text) }.first
            return unless id && image && price

            { platform: SearchUrl::PLATFORM, external_id: id, name: image["alt"].to_s.strip, price: price,
              product_url: "https://#{SearchUrl::HOST}/item/#{id}", thumbnail_url: image["src"],
              sold: link.at_css('img[alt="sold"]').present? }
          end

          # 「¥1,200」などの表示価格を整数にする。DBの整数の上限を超える値は価格なしとする
          def price(text)
            match = text.to_s.strip.match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
            value = match && match[1].delete(",").to_i
            value if value && value <= ProductMonitoring::CrawlResult::MAX_PRICE
          end

          def next_url(uri, page)
            link = page.css("a[href]").find { |node| node.at_css('img[alt="次へボタンアイコン"]') }
            return unless link

            next_uri = URI.join(uri.to_s, link["href"])
            raise "Unexpected next page URL" unless valid_next_url?(next_uri, uri)

            next_uri
          end

          def valid_next_url?(next_uri, uri)
            next_uri.is_a?(URI::HTTPS) && next_uri.host == SearchUrl::HOST && next_uri.port == 443 &&
              next_uri.path == uri.path && next_uri.userinfo.nil?
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
