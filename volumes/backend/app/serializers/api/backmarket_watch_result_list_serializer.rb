module Api
  class BackmarketWatchResultListSerializer
    def initialize(backmarket_watch_targets)
      @backmarket_watch_targets = backmarket_watch_targets
    end

    def as_json(_opts = {})
      {
        backmarket_watch_results: @backmarket_watch_targets.filter_map { |target| build_result(target) }
      }
    end

    private

    def build_result(target)
      result = target.backmarket_watch_results.max_by(&:crawled_at)
      return nil unless result

      {
        backmarket_watch_target_id: target.id,
        watch_name: target.name,
        url: target.url,
        name: result.name,
        price: result.price,
        condition: result.condition,
        memory: result.memory,
        storage: result.storage,
        cpu: result.cpu,
        stock_status: result.stock_status,
        crawled_at: result.crawled_at
      }
    end
  end
end
