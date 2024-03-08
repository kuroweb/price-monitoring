# クロール結果のコレクションクラス
module Crawl
  module Mercari
    class CrawlResults
      attr_reader :results

      def initialize(results = [])
        @results = results
      end

      def add(result)
        results.push(result)
      end

      def mercari_ids
        results.map(&:mercari_id)
      end
    end
  end
end
