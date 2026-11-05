module ProductCrawlSettings
  # 保存済みの条件で検索結果URLを取得し、採用した出品を商品計測結果に保存する
  class SyncResults
    FILTER_KEYS = %i[required_keywords exclude_keywords min_price max_price].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(product_crawl_setting:)
      @product_crawl_setting = product_crawl_setting
    end

    def call
      crawled = Crawl::Search::Crawler.call(params: crawl_params)
      ProductCrawlResult.transaction do
        save_matched(crawled[:results].select { |result| (result[:reasons] - ["excluded_listing"]).empty? })
        delete_unmatched
      end
      crawled
    end

    private

    attr_reader :product_crawl_setting

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
      return if results.empty?

      rows = results.map do |result|
        {
          product_crawl_setting_id: product_crawl_setting.id,
          platform: result[:platform],
          external_id: result[:external_id],
          name: result[:name],
          product_url: result[:product_url],
          thumbnail_url: result[:thumbnail_url],
          price: result[:price] || 0
        }
      end
      ProductCrawlResult.upsert_all(rows, record_timestamps: true)
    end

    # 条件の変更で一致しなくなった保存済みの結果を削除する
    def delete_unmatched
      ids = ProductCrawlResult.where(product_crawl_setting_id: product_crawl_setting.id).reject do |result|
        Crawl::Search::Filter.call(item: result.attributes.symbolize_keys, params: filter_params).empty?
      end.map(&:id)
      ProductCrawlResult.where(id: ids).delete_all if ids.any?
    end
  end
end
