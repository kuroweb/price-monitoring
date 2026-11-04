# 落札相場画面のクローラ
module Crawl
  module YahooFleamarket
    module SyncProducts
      module Unpublished
        class Crawler
          RETRY_COUNT = 5
          MAX_SIZE = 500

          def initialize(product:)
            @product = product
          end

          def execute # rubocop:disable Metrics/MethodLength
            # 一覧は SSR 済みの HTML から読むので、スクリプトは不要（動かすとサムネイルの src がエラー画像に書き換わる）
            Crawl::Client.execute(block_scripts: true) do |page|
              start = 1
              loop do
                break if start > MAX_SIZE

                Retryable.retryable(tries: RETRY_COUNT) do
                  page.goto(url(start))
                  page.reload
                  break if not_exist_results?(page)

                  append_results(page, start:)
                end

                break if stop?(page, start)

                start += 100
              end
            end

            raise StandardError, crawl_results.errors unless crawl_results.valid?

            crawl_results
          end

          private

          attr_reader :product

          def append_results(page, start:)
            doms = Crawl::YahooFleamarket::SyncProducts::ListItem.product_doms(page)
            raise Crawl::YahooFleamarket::ListStructureChanged if start == 1 && doms.empty?

            doms.each do |dom|
              result = Crawl::YahooFleamarket::SyncProducts::CrawlResult.new(
                external_id: Crawl::YahooFleamarket::SyncProducts::ListItem.external_id(dom),
                seller_id: Crawl::YahooFleamarket::SyncProducts::ListItem.seller_id(dom),
                name: Crawl::YahooFleamarket::SyncProducts::ListItem.name(dom),
                price: Crawl::YahooFleamarket::SyncProducts::ListItem.price(dom),
                thumbnail_url: Crawl::YahooFleamarket::SyncProducts::ListItem.thumbnail_url(dom),
                published: false,
                bought_date: Crawl::YahooFleamarket::SyncProducts::ListItem.bought_date(dom)
              )

              crawl_results.add(result)
            end
          end

          def url(start)
            UrlGenerator.new(yahoo_auction_crawl_setting: product.yahoo_auction_crawl_setting, start:).generate
          end

          def stop?(page, start)
            not_exist_results?(page) || !Crawl::YahooFleamarket::SyncProducts::ListItem.next_page?(page, start)
          end

          def not_exist_results?(page)
            page.query_selector(".Notice__wandQuery")
          end

          def crawl_results
            @crawl_results ||= Crawl::YahooFleamarket::SyncProducts::CrawlResults.new
          end
        end
      end
    end
  end
end
