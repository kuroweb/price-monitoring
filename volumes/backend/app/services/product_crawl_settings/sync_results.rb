module ProductCrawlSettings
  # 保存済みの条件で検索結果URLを取得し、採用した出品を商品計測結果に保存する
  class SyncResults
    FILTER_KEYS = %i[required_keywords exclude_keywords min_price max_price].freeze
    MAX_DETAIL_JOBS = 50

    def self.call(...)
      new(...).call
    end

    def initialize(product_crawl_setting:)
      @product_crawl_setting = product_crawl_setting
    end

    def call
      crawled = ProductMonitoring::Crawler.call(params: crawl_params)
      ProductCrawlResult.transaction do
        save_matched(crawled[:results].select { |result| (result[:reasons] - ["excluded_listing"]).empty? })
        delete_unmatched
      end
      enqueue_details(crawled) if crawled[:sources].all? { |source| source[:status] == "succeeded" }
      crawled
    end

    private

    attr_reader :product_crawl_setting

    def enqueue_details(crawled)
      seen_ids = crawled[:results].select { |result| result[:platform] == "mercari" }.pluck(:external_id)
      ids = detail_candidates(seen_ids).order(:updated_at).pluck(:external_id).uniq.first(MAX_DETAIL_JOBS)
      ids.each do |external_id|
        ProductCrawlSettings::SyncDetailJob.perform_async(external_id)
      end
    end

    def detail_candidates(seen_ids)
      scope = product_crawl_setting.product_crawl_results.where(platform: "mercari")
      missing = scope.where.not(sold: true).or(scope.where(sold: nil)).where.not(external_id: seen_ids)
      undated = scope.where(sold: true, bought_date: nil)
      missing.or(undated)
    end

    def filter_params
      product_crawl_setting.attributes.symbolize_keys.slice(*FILTER_KEYS)
    end

    def crawl_params
      filter_params.merge(
        search_urls: product_crawl_setting.search_urls,
        exclude_external_ids: product_crawl_setting.product_crawl_results.excluded.pluck(:external_id)
      )
    end

    # 除外した出品も価格などは更新する。excluded_at は行に含めないので上書きしない
    def save_matched(results)
      results = results.reject { |result| result[:price].nil? }
      return if results.empty?

      rows = results.map { |result| listing_row(result) }
      ProductCrawlResult.upsert_all(rows, record_timestamps: true,
                                          update_only: %i[name product_url thumbnail_url price])
      update_sold(results)
    end

    def listing_row(result)
      {
        product_crawl_setting_id: product_crawl_setting.id,
        platform: result[:platform],
        external_id: result[:external_id],
        name: result[:name],
        product_url: result[:product_url],
        thumbnail_url: result[:thumbnail_url],
        price: result[:price],
        sold: result[:sold]
      }
    end

    def update_sold(results)
      available_ids = results.select { |result| result[:sold] == false }.pluck(:external_id)
      sold_ids = results.select { |result| result[:sold] }.pluck(:external_id)
      scope = product_crawl_setting.product_crawl_results
      scope.where(external_id: available_ids, sold: nil).update_all(sold: false) if available_ids.any?
      scope.where(external_id: sold_ids).update_all(sold: true) if sold_ids.any?
    end

    # 条件の変更で一致しなくなった保存済みの結果を削除する
    def delete_unmatched
      ids = ProductCrawlResult.where(product_crawl_setting_id: product_crawl_setting.id).reject do |result|
        ProductMonitoring::Filter.call(item: result.attributes.symbolize_keys, params: filter_params).empty?
      end.map(&:id)
      ProductCrawlResult.where(id: ids).delete_all if ids.any?
    end
  end
end
