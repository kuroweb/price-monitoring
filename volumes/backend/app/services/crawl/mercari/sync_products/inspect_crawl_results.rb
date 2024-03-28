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
          inspect_required_keyword(crawl_result) && inspect_exclude_keyword(crawl_result)
        end

        def inspect_required_keyword(crawl_result)
          required_keywords.all? { |keyword| normalize_keyword(crawl_result.name).include?(keyword) }
        end

        def inspect_exclude_keyword(crawl_result)
          exclude_keywords.all? { |keyword| normalize_keyword(crawl_result.name).exclude?(keyword) }
        end

        def required_keywords
          @required_keywords ||=
            mercari_crawl_setting.mercari_crawl_setting_required_keywords
                                 .pluck(:keyword)
                                 .map { |keyword| normalize_keyword(keyword) }
        end

        def exclude_keywords
          @exclude_keywords ||=
            mercari_crawl_setting.mercari_crawl_setting_exclude_keywords
                                 .pluck(:keyword)
                                 .map { |keyword| normalize_keyword(keyword) }
        end

        def normalize_keyword(keyword)
          keyword.tr("Ａ-Ｚ０-９", "A-Z0-9").downcase
        end
      end
    end
  end
end
