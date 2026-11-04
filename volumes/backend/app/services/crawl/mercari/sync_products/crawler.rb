module Crawl
  module Mercari
    module SyncProducts
      class Crawler
        RETRY_COUNT = 5
        MAX_PAGE = 5
        NEXT_BUTTON_SELECTOR = "[data-testid='pagination-next-button']".freeze
        ITEM_LINK_SELECTOR = "li[data-testid='item-cell'] a".freeze
        NEXT_PAGE_TIMEOUT_MS = 20_000
        FIRST_ITEM_CHANGED_SCRIPT = <<~JS.squish.freeze
          href => {
            const a = document.querySelector("#{ITEM_LINK_SELECTOR}");
            return a && a.getAttribute('href') !== href;
          }
        JS

        def initialize(product:)
          @product = product
        end

        def execute # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          Crawl::Client.execute do |page|
            start = 0
            loop do
              break if start > MAX_PAGE

              Retryable.retryable(tries: RETRY_COUNT) do |retries, _exception|
                Rails.logger.info("Execute mercari crawl process. product_id: #{product.id} page: #{start}")

                open_page(page, start, retried: retries.positive?)
                load(page)

                break if no_results?(page)

                append_results(page)
              end

              break unless exists_next_page?(page)

              start += 1
            end
          end

          raise StandardError, crawl_results.errors unless crawl_results.valid?

          crawl_results
        end

        attr_reader :product

        def url(start)
          UrlGenerator.new(
            mercari_crawl_setting: product.mercari_crawl_setting, page: start
          ).generate
        end

        # 2 ページ目以降は「次へ」で遷移する。URL を開き直すと、request の遮断で HTTP キャッシュが効かず全アセットを取り直す
        def open_page(page, start, retried:)
          return page.goto(url(start)) if start.zero? || retried

          click_next(page)
        end

        def click_next(page)
          first_href = first_item_href(page)
          page.query_selector(NEXT_BUTTON_SELECTOR).click
          page.wait_for_function(FIRST_ITEM_CHANGED_SCRIPT, arg: first_href, timeout: NEXT_PAGE_TIMEOUT_MS)
        end

        def first_item_href(page)
          page.query_selector(ITEM_LINK_SELECTOR)&.get_attribute("href")
        end

        def no_results?(page)
          page.query_selector(".merEmptyState")
        end

        def exists_next_page?(page)
          page.query_selector(NEXT_BUTTON_SELECTOR)
        end

        def load(page)
          sleep(2)
          count = 0
          loop do
            break if count > 30

            page.mouse.wheel(0, 200)
            sleep(0.005)

            count += 1
          end
        end

        def append_results(page)
          doms = product_doms(page)
          doms.each do |dom|
            result = CrawlResult.new(
              external_id: external_id(dom),
              name: name(dom),
              price: price(dom),
              thumbnail_url: thumbnail_url(dom),
              published: published(dom)
            )
            crawl_results.add(result)
          end
        end

        def product_doms(page)
          search_item_dom = page.query_selector("div[data-testid='search-item-grid']")
          search_item_dom.query_selector_all("li[data-testid='item-cell']")
                         .reject { |dom| not_crawlable?(dom) }
        end

        def not_crawlable?(dom)
          skeleton?(dom) || shop_item?(dom)
        end

        # 読み込み前のセルは商品リンクを持たない
        def skeleton?(dom)
          dom.query_selector("a").nil?
        end

        def shop_item?(dom)
          href = dom.query_selector("a").get_attribute("href")
          href[%r{product/([^/]+)}, 1].present?
        end

        def external_id(dom)
          href = dom.query_selector("a").get_attribute("href")
          href[%r{item/([^/]+)}, 1]
        end

        def name(dom)
          dom.query_selector("[data-testid='thumbnail-item-name']").inner_text
        end

        def price(dom)
          dom.query_selector("[data-testid='item-tile-price']").inner_text.gsub(/¥|,/, "")
        end

        # 画像リクエストを遮断すると img の src が設定されないため、external_id から組み立てる
        def thumbnail_url(dom)
          "https://static.mercdn.net/thumb/item/webp/#{external_id(dom)}_1.jpg"
        end

        def published(dom)
          dom.query_selector("img[alt$='売り切れ']").blank?
        end

        def crawl_results
          @crawl_results ||= CrawlResults.new
        end
      end
    end
  end
end
