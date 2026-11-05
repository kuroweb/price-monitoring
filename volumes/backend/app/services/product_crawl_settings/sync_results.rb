module ProductCrawlSettings
  # 保存済みの条件で検索結果URLを取得し、採用した出品を商品計測結果に保存する
  class SyncResults
    FILTER_KEYS = %i[required_keywords exclude_keywords exclude_external_ids min_price max_price].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(product_crawl_setting:)
      @product_crawl_setting = product_crawl_setting
    end

    def call
      preview = Crawl::Search::Preview.call(params: preview_params)
      ProductCrawlResult.transaction do
        save_accepted(preview[:results].select { |result| result[:accepted] })
        delete_unmatched
      end
      preview
    end

    private

    attr_reader :product_crawl_setting

    def preview_params
      product_crawl_setting.attributes.symbolize_keys.slice(:search_urls, *FILTER_KEYS)
    end

    def save_accepted(results)
      return if results.empty?

      rows = results.map do |result|
        {
          product_crawl_setting_id: product_crawl_setting.id,
          platform: result[:platform],
          external_id: result[:external_id],
          name: result[:name],
          product_url: result[:product_url],
          price: result[:price] || 0
        }
      end
      ProductCrawlResult.upsert_all(rows, record_timestamps: true)
    end

    # 条件の変更や出品の除外で一致しなくなった保存済みの結果を削除する
    def delete_unmatched
      filter_params = preview_params.slice(*FILTER_KEYS)
      ids = ProductCrawlResult.where(product_crawl_setting_id: product_crawl_setting.id).reject do |result|
        Crawl::Search::Filter.call(item: result.attributes.symbolize_keys, params: filter_params).empty?
      end.map(&:id)
      ProductCrawlResult.where(id: ids).delete_all if ids.any?
    end
  end
end
