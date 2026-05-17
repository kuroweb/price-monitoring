module Api
  class BackmarketRecentListSerializer
    LIMIT_PER_TARGET = 5

    def initialize
      @backmarket_watch_targets = BackmarketWatchTarget.includes(:backmarket_watch_results).order(id: :desc)
    end

    def as_json(_opts = {})
      {
        backmarket_recent_sections: @backmarket_watch_targets.filter_map { |target| build_section(target) }
      }
    end

    private

    def build_section(target)
      results = target.backmarket_watch_results.sort_by(&:crawled_at).reverse.first(LIMIT_PER_TARGET)
      return nil if results.blank?

      {
        backmarket_watch_target_id: target.id,
        watch_name: target.name,
        url: target.url,
        results: results.map { |result| build_result(result) }
      }
    end

    def build_result(result)
      {
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
