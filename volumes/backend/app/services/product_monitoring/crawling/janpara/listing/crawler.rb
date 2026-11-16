module ProductMonitoring
  module Crawling
    module Janpara
      module Listing
        class Crawler
          class NonSuccessResponse < StandardError; end

          MAX_PAGES = 5
          # 実際の1ページの件数（じゃんぱらは12件）より大きくする。超えた分は取得しないので、一覧を最後まで取得できなかったとする
          MAX_RESULTS_PER_PAGE = 200
          TIMEOUT_SECONDS = 60
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          FETCH_TRIES = 5
          # WAF（SiteGuard）が古い User-Agent を HTTP 500 で拒否するため、新しい User-Agent で取得する
          USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " \
                       "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36".freeze

          def self.call(...)
            new(...).call
          end

          def initialize(product_crawl_setting:)
            @product_crawl_setting = product_crawl_setting
            @listings = {}
            @truncated = false
          end

          # 設定の検索結果URLのうちじゃんぱらの分を、ページを送りながら取得する。全URLが失敗したらジョブを失敗にして再試行する。
          # 一覧から消えた出品を売り切れにするため、全URLを最後のページまで取得できたかも返す
          def call
            succeeded = UrlRouter.call(product_crawl_setting:).fetch(Janpara, []).map { |url| crawl(url) }
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

          # JavaScript なしで描画されるので、スクリプトを止めて取得する。
          # サイトに拒否されるプロキシがあるので、非 2xx なら接続し直して別のプロキシで試す
          def fetch_page(uri)
            Retryable.retryable(tries: FETCH_TRIES, on: NonSuccessResponse) do
              Client.execute(block_scripts: true, user_agent: USER_AGENT) do |page|
                response = page.goto(uri.to_s)
                raise NonSuccessResponse, "Non-success HTTP response" unless response&.status&.between?(200, 299)

                checked_content(page)
              end
            end
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
