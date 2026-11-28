module ProductMonitoring
  module Crawling
    module YahooAuction
      module ListPage
        class Crawler
          MAX_PAGES = 5
          MAX_RESULTS_PER_PAGE = 100
          TIMEOUT_SECONDS = 180
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024
          LIST_READY = <<~JS.freeze
            () => document.querySelector('li:has(> div a[href*="jp/auction/"]), .Notice__wandQuery') ||
              document.body?.innerText.includes('条件に一致する商品は見つかりませんでした')
          JS

          def self.call(...)
            new(...).call
          end

          def initialize(crawl_setting:)
            @crawl_setting = crawl_setting
            @listings = {}
          end

          def call
            succeeded = UrlRouter.call(crawl_setting:).fetch(YahooAuction, []).map { |url| crawl(url) }
            raise "All search URLs failed" if succeeded.present? && succeeded.none?

            listings.values
          end

          private

          attr_reader :crawl_setting, :listings

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
                uri = search_uri(uri)
                page_results, uri = Parser.call(uri, Nokogiri::HTML(fetch_page(uri)))
                results.concat(page_results.first(MAX_RESULTS_PER_PAGE))
                return results if uri.nil?
              end
            end
            results
          end

          # abatch=1,2 で Yahoo!フリマの出品を除く
          def search_uri(uri)
            query = URI.decode_www_form(uri.query)
            query.reject! { |key, _| %w[mode n abatch].include?(key) }
            query.push(%w[mode 2], %w[n 100], ["abatch", "1,2"])
            uri.dup.tap { |result| result.query = URI.encode_www_form(query) }
          end

          # 画像を遮断するとサムネイルがエラー画像に置き換わるので、画像の読み込みを許可する
          def fetch_page(uri)
            Client.execute(allow_images: true) do |page|
              response = page.goto(uri.to_s)
              raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

              checked_content(page)
              page.wait_for_function(LIST_READY)
              checked_content(page)
            end
          end

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
