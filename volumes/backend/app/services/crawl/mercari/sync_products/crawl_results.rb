# クロール結果のコレクションクラス
module Crawl
  module Mercari
    module SyncProducts
      class CrawlResults
        attr_reader :results

        def initialize(results = [])
          @results = results
        end

        def add(result)
          results.push(result)
        end

        def unpublished_results
          results.reject(&:published)
        end
      end
    end
  end
end
