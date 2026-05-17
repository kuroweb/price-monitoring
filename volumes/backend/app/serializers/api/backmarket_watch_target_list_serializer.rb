module Api
  class BackmarketWatchTargetListSerializer
    def initialize(backmarket_watch_targets)
      @backmarket_watch_targets = backmarket_watch_targets
    end

    def as_json(_opts = {})
      {
        backmarket_watch_targets: @backmarket_watch_targets.as_json
      }
    end
  end
end
