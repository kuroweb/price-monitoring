module ProductMonitoring
  # 一覧にある販売状態と、完全な検索結果から消えた出品を反映する
  class SyncSearchSoldStatus
    def self.call(...)
      new(...).call
    end

    def initialize(product_crawl_setting:, crawled:, platform:)
      @product_crawl_setting = product_crawl_setting
      @crawled = crawled
      @platform = platform
    end

    def call
      results = crawled[:results].select { |result| result[:platform] == platform }
      scope = product_crawl_setting.product_crawl_results.where(platform:)
      update_search_sold(scope, results)
      sell_out_missing(scope, results.pluck(:external_id))
    end

    private

    attr_reader :product_crawl_setting, :crawled, :platform

    # 価格が無くても反映する。同じ出品が両方で返るときは販売中を後に適用する。
    def update_search_sold(scope, results)
      [true, false].each do |sold|
        ids = results.select { |result| result[:sold] == sold }.pluck(:external_id)
        scope.where(external_id: ids).update_all(sold:) if ids.any? # rubocop:disable Rails/SkipsModelValidations
      end
    end

    def sell_out_missing(scope, returned_ids)
      return unless site_fetch_succeeded?

      missing = scope.where(updated_at: ..DetailCandidates::DETAIL_RECHECK_INTERVAL.ago)
      missing = missing.where.not(external_id: returned_ids) if returned_ids.any?
      missing.update_all(sold: true) if missing.exists? # rubocop:disable Rails/SkipsModelValidations
    end

    def site_fetch_succeeded?
      site_sources = crawled[:sources].select { |source| source[:platform] == platform }
      site_sources.any? && site_sources.all? { |source| source[:status] == "succeeded" && !source[:truncated] }
    end
  end
end
