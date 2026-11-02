# 落札相場画面のクローラ
module Crawl
  module YahooAuction
    module SyncProducts
      module Unpublished
        class Crawler
          include ListPage

          RETRY_COUNT = 5
          MAX_SIZE = 500

          def initialize(product:)
            @product = product
          end

          def execute # rubocop:disable Metrics/MethodLength
            Crawl::Client.execute do |page|
              start = 1
              loop do
                break if start > MAX_SIZE

                Retryable.retryable(tries: RETRY_COUNT) do
                  page.goto(url(start))
                  wait_for_list(page)
                  break if not_exist_results?(page)

                  append_results(page, first_page: start == 1)
                end

                break if stop?(page)

                start += 100
              end
            end

            raise StandardError, crawl_results.errors unless crawl_results.valid?

            crawl_results
          end

          private

          attr_reader :product

          def append_results(page, first_page:) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
            items = product_items(page)
            crawlable_count = 0
            added_count = 0

            items.each do |dom|
              next if not_crawlable?(dom)

              crawlable_count += 1
              price = closed_price(dom)
              next if price.nil?

              bought_date = auction_end_datetime(dom, mode: :unpublished)

              result = Crawl::YahooAuction::SyncProducts::CrawlResult.new(
                external_id: external_id(dom),
                seller_id: seller_id(dom),
                name: name(dom),
                price:,
                buyout_price: nil,
                thumbnail_url: thumbnail_url(dom),
                published: false,
                bought_date:,
                end_date: bought_date
              )

              crawl_results.add(result)
              added_count += 1
            end

            assert_first_page_products!(
              page,
              first_page:,
              items_count: items.size,
              crawlable_count:,
              added_count:
            )
          end

          def url(start)
            UrlGenerator.new(yahoo_auction_crawl_setting: product.yahoo_auction_crawl_setting, start:).generate
          end

          def stop?(page)
            not_exist_results?(page) || not_exist_next_page?(page)
          end

          def crawl_results
            @crawl_results ||= Crawl::YahooAuction::SyncProducts::CrawlResults.new
          end
        end
      end
    end
  end
end
