module ProductMonitoring
  class WatchListings
    LIMIT = 8

    def self.call(product_watch_setting:)
      filter = LowestListings.filter_params(product_watch_setting)
      listings = []
      seen = Set.new
      ProductCrawlResult.transaction do
        LowestListings.candidates(filter).find_each(
          cursor: %i[price id], order: %i[asc asc], batch_size: LowestListings::BATCH_SIZE
        ) do |result|
          next unless LowestListings.matches?(result, filter)
          next unless seen.add?([result.platform, result.external_id])

          listings << result
          break if listings.size == LIMIT
        end
      end
      listings
    end
  end
end
