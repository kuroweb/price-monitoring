module Crawl
  module Mercari
    module SyncProducts
      class Crawler
        def initialize(product:)
          @product = product
        end

        def execute # rubocop:disable Metrics/MethodLength
          Crawl::Client.execute do |browser|
            page = browser.new_page

            start = 0
            loop do
              break if start > 20

              Retryable.retryable(tries: 3) do
                page.goto(url(start))
                break if no_results?(page)

                load(page)
                append_results(page)
              end

              break unless exists_next_page?(page)

              start += 1
            end
          end

          crawl_results
        end

        attr_reader :product

        def url(start)
          UrlGenerator.new(
            mercari_crawl_setting: product.mercari_crawl_setting, page: start
          ).generate
        end

        def no_results?(page)
          page.query_selector(".merEmptyState")
        end

        def exists_next_page?(page)
          page.query_selector("[data-testid='pagination-next-button']")
        end

        def load(page)
          sleep(0.5)
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
              mercari_id: mercari_id(dom),
              name: name(dom),
              price: price(dom),
              thumbnail_url: thumbnail_url(dom),
              published: published(dom)
            )
            crawl_results.add(result)
          end
        end

        def product_doms(page)
          page.query_selector_all("li[data-testid='item-cell']")
              .reject { |dom| not_crawlable?(dom) }
        end

        def not_crawlable?(dom)
          href = dom.query_selector("a").get_attribute("href")
          key = href[%r{product/([^/]+)}, 1]
          skeleton = dom.query_selector(".merSkeleton")

          key.present? || skeleton.present?
        end

        def mercari_id(dom)
          href = dom.query_selector("a").get_attribute("href")
          href[%r{item/([^/]+)}, 1]
        end

        def name(dom)
          dom.query_selector("[data-testid='thumbnail-item-name']").inner_text
        end

        def price(dom)
          dom.query_selector("[class^='number']").inner_text.gsub(/,/, "")
        end

        def thumbnail_url(dom)
          dom.query_selector("img").get_attribute("src")
        end

        def published(dom)
          dom.query_selector("[aria-label='売り切れ']").blank?
        end

        def crawl_results
          @crawl_results ||= CrawlResults.new
        end
      end
    end
  end
end
