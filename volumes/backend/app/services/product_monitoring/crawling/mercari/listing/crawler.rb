module ProductMonitoring
  module Crawling
    module Mercari
      module Listing
        class Crawler
          MAX_PAGES = 5
          # 実際の1ページの件数（メルカリは120件）より大きくする。超えた分は取得しないので、一覧を最後まで取得できなかったとする
          MAX_RESULTS_PER_PAGE = 200
          # 1ページの描画とスクロールに十数秒かかる
          TIMEOUT_SECONDS = 180
          MAX_SCROLLS = 60
          # 出品のセルは表示範囲に入ってから中身が描画される。セルが1つも無いうちは、空結果の表示が出るまで待つ
          RENDERED_SCRIPT = <<~JS.freeze
            () => {
              const cells = [...document.querySelectorAll("li[data-testid='item-cell']")];
              if (cells.length === 0) return document.querySelector(".merEmptyState") !== null;
              return cells.every((cell) => cell.querySelector("a"));
            }
          JS
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
                page_results, uri = ListPage.call(uri, Nokogiri::HTML(fetch_page(uri)))
                @truncated = true if page_results.size > MAX_RESULTS_PER_PAGE
                results.concat(page_results.first(MAX_RESULTS_PER_PAGE))
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
              render_all(page)
              checked_content(page)
            end
          end

          # すべてのセルが描画されるまで下へスクロールする。描画しきれなければ一覧を最後まで取得できなかったとする
          def render_all(page)
            MAX_SCROLLS.times do
              return if page.evaluate(RENDERED_SCRIPT)

              page.mouse.wheel(0, 800)
              Kernel.sleep(0.2)
            end
            @truncated = true
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
