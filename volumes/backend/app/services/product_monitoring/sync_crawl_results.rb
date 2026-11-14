module ProductMonitoring
  # 保存済みの条件で検索結果URLを取得し、採用した出品を商品計測結果に保存する
  class SyncCrawlResults
    def self.call(...)
      new(...).call
    end

    def initialize(product_crawl_setting:)
      @product_crawl_setting = product_crawl_setting
    end

    def call
      crawled = ProductMonitoring::Crawler.call(params: crawl_params)
      matched = matched_results(crawled)
      details = DetailCandidates.new(product_crawl_setting: product_crawl_setting)
      newly_sold = details.newly_sold(matched)
      ProductCrawlResult.transaction do
        save_matched(matched)
        [Sites::Janpara::PLATFORM, Sites::Iosys::PLATFORM].each do |platform|
          sync_search_sold(crawled, platform)
        end
        CleanseCrawlResults.call(product_crawl_setting:)
      end
      details.enqueue(crawled, newly_sold)
      crawled
    end

    private

    attr_reader :product_crawl_setting

    def matched_results(crawled)
      crawled[:results].select { |result| (result[:reasons] - ["excluded_listing"]).empty? }
    end

    def filter_params
      # 保存時と削除時で条件の項目を食い違わせないため、削除側の定義を使う
      product_crawl_setting.attributes.symbolize_keys.slice(*CleanseCrawlResults::FILTER_KEYS)
    end

    def crawl_params
      filter_params.merge(
        keyword: product_crawl_setting.keyword,
        platforms: product_crawl_setting.platforms,
        search_urls: product_crawl_setting.search_urls,
        exclude_external_ids: product_crawl_setting.product_crawl_results.excluded.pluck(:external_id)
      )
    end

    # 除外した出品も価格などは更新する。excluded_at は行に含めないので上書きしない
    def save_matched(results)
      results = results.reject { |result| result[:price].nil? }
      return if results.empty?

      upsert_listings(results.map { |result| listing_row(result) })
      update_sold(results)
    end

    def upsert_listings(rows)
      ProductCrawlResult.upsert_all(rows, record_timestamps: true, on_duplicate: Arel.sql(<<~SQL.squish))
        updated_at = IF(name <=> VALUES(name) AND product_url <=> VALUES(product_url)
          AND thumbnail_url <=> VALUES(thumbnail_url) AND price <=> VALUES(price)
          AND end_date <=> VALUES(end_date) AND buyout_price <=> COALESCE(VALUES(buyout_price), buyout_price),
          product_crawl_results.updated_at, VALUES(updated_at)),
        name = VALUES(name), product_url = VALUES(product_url), thumbnail_url = VALUES(thumbnail_url),
        price = VALUES(price), end_date = VALUES(end_date),
        buyout_price = COALESCE(VALUES(buyout_price), product_crawl_results.buyout_price),
        bought_date = COALESCE(product_crawl_results.bought_date, IF(VALUES(sold), VALUES(bought_date), NULL))
      SQL
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
        sold: result[:sold],
        buyout_price: result[:buyout_price],
        end_date: result[:end_date],
        bought_date: result[:bought_date]
      }
    end

    def update_sold(results)
      available_ids = results.select { |result| result[:sold] == false }.pluck(:external_id)
      sold_ids = results.select { |result| result[:sold] }.pluck(:external_id)
      scope = product_crawl_setting.product_crawl_results
      scope.where(external_id: available_ids, sold: nil).update_all(sold: false) if available_ids.any?
      scope.where(external_id: sold_ids).update_all(sold: true) if sold_ids.any?
    end

    # 詳細取得の無いサイトは、成功した検索から消えた行を売り切れにする。
    # 対象サイトの source が 1 件以上あり、そのすべてが成功しているときだけ対象にする。
    # 価格が無く保存しない出品も検索結果に含める。
    def sync_search_sold(crawled, platform)
      returned_ids = crawled[:results].select { |result| result[:platform] == platform }.pluck(:external_id)
      scope = product_crawl_setting.product_crawl_results.where(platform:)
      returned = scope.where(external_id: returned_ids)
      returned.update_all(sold: false) if returned_ids.any? && returned.exists?
      sell_out_missing(scope, returned_ids, crawled[:sources], platform)
    end

    def sell_out_missing(scope, returned_ids, sources, platform)
      return unless site_fetch_succeeded?(sources, platform)

      missing = scope.where(updated_at: ..DetailCandidates::DETAIL_RECHECK_INTERVAL.ago)
      missing = missing.where.not(external_id: returned_ids) if returned_ids.any?
      missing.update_all(sold: true) if missing.exists?
    end

    def site_fetch_succeeded?(sources, platform)
      site_sources = sources.select { |source| source[:platform] == platform }
      site_sources.any? && sources_succeeded?(site_sources)
    end

    def sources_succeeded?(sources)
      sources.all? { |source| source[:status] == "succeeded" }
    end
  end
end
