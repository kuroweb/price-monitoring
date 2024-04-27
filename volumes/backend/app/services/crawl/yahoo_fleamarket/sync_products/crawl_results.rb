# クロール結果のコレクションクラス
module Crawl
  module YahooFleamarket
    module SyncProducts
      class CrawlResults
        attr_reader :results

        def initialize(results = [])
          @results = results
        end

        def add(result)
          results.push(result)
        end

        def valid?
          results.all?(&:valid?)
        end

        def errors
          results.map.with_index do |result, index|
            "CrawlResult #{index + 1}: #{result.errors.full_messages.join(', ')}" if result.invalid?
          end.compact
        end
      end
    end
  end
end
