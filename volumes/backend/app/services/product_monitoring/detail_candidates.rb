module ProductMonitoring
  class DetailCandidates
    MAX_DETAIL_JOBS = 50
    DETAIL_RECHECK_INTERVAL = 3.hours

    def initialize(product_crawl_setting:)
      @product_crawl_setting = product_crawl_setting
    end

    def newly_sold(results)
      detail_sites.to_h { |site| [site::PLATFORM, newly_sold_ids(results, site::PLATFORM)] }
    end

    def enqueue(crawled, newly_sold)
      candidates = candidates_for(crawled, newly_sold)
      selected = candidates.first(MAX_DETAIL_JOBS)
      log_detail_candidates(candidates.size, selected.size)
      selected.each do |platform, external_id, _updated_at|
        if platform == "mercari"
          ProductMonitoring::CrawlDetailJob.perform_async(external_id)
        else
          ProductMonitoring::CrawlDetailJob.perform_async(external_id, platform)
        end
      end
    end

    private

    attr_reader :product_crawl_setting

    def detail_sites
      ProductMonitoring::UrlRouter::SITES.select { |site| site.respond_to?(:fetch_detail) }
    end

    def newly_sold_ids(results, platform)
      sold_ids = results.select do |result|
        result[:platform] == platform && result[:sold] && !result[:price].nil?
      end.pluck(:external_id)
      already_sold = product_crawl_setting.product_crawl_results
                                          .where(platform: platform, external_id: sold_ids, sold: true)
      sold_ids - already_sold.pluck(:external_id)
    end

    def candidates_for(crawled, newly_sold)
      detail_sites.flat_map { |site| site_candidates(site, crawled, newly_sold) }.sort_by(&:last)
    end

    def site_candidates(site, crawled, newly_sold)
      platform = site::PLATFORM
      seen = crawled[:results].select { |result| result[:platform] == platform }.pluck(:external_id)
      detail_candidates(platform, seen, newly_sold.fetch(platform)).order(:updated_at)
                                                                   .pluck(:external_id, :updated_at)
                                                                   .map { |id, updated_at| [platform, id, updated_at] }
    end

    def log_detail_candidates(candidate_count, enqueued_count)
      Rails.logger.info("Product crawl detail candidates: setting_id=#{product_crawl_setting.id} " \
                        "candidates=#{candidate_count} enqueued=#{enqueued_count}")
    end

    def detail_candidates(platform, seen_ids, newly_sold_ids)
      scope = product_crawl_setting.product_crawl_results.where(platform: platform)
      due = scope.where(updated_at: ...DETAIL_RECHECK_INTERVAL.ago)
      missing = due.where.not(sold: true).or(due.where(sold: nil)).where.not(external_id: seen_ids)
      undated = scope.where(sold: true, bought_date: nil)
      undated = undated.merge(due).or(undated.where(external_id: newly_sold_ids))
      missing.or(undated)
    end
  end
end
