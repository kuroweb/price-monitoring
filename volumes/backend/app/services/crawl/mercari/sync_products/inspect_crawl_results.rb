# クローリング結果を検査する
module Crawl
  module Mercari
    module SyncProducts
      class InspectCrawlResults
        def initialize(mercari_crawl_setting:, crawl_results:)
          @mercari_crawl_setting = mercari_crawl_setting
          @crawl_results = crawl_results
        end

        def execute
          inspected_crawl_results = crawl_results.results.select { |crawl_result| inspect(crawl_result) }
          CrawlResults.new(inspected_crawl_results)
        end

        private

        attr_reader :mercari_crawl_setting, :crawl_results

        def inspect(crawl_result)
          inspect_exclude_keyword(crawl_result)
        end

        def inspect_exclude_keyword(crawl_result)
          exclude_keywords.all? { |keyword| crawl_result.name.downcase.exclude?(keyword) }
        end

        def exclude_keywords
          @exclude_keywords ||= mercari_crawl_setting.mercari_crawl_setting_exclude_keywords.pluck(:keyword)
        end
      end
    end
  end
end
