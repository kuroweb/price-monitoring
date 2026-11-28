module Api
  module V1
    module ProductMonitoring
      # 収集結果。crawl_setting_id でその収集設定の収集結果に絞り、excluded=true で除外した収集結果だけを返す
      class CrawlResultsController < Api::ApplicationController
        PREVIEW_COUNT = 8
        ExtractionCriteria = ::ProductMonitoring::Monitor::ExtractionCriteria
        MatchingCrawlResults = ::ProductMonitoring::Search::MatchingCrawlResults

        def index
          crawl_results = filtered_results
          if params[:crawl_setting_id].present?
            results = crawl_results.where(crawl_setting_id: params[:crawl_setting_id])
            render json: { crawl_results: results.order(id: :desc).as_json }, status: :ok
          else
            render json: preview_results(crawl_results), status: :ok
          end
        end

        def search
          monitor = ::ProductMonitoring::Monitor.new(search_criteria)
          result = MatchingCrawlResults.call(monitor:, **search_query)
          render json: { crawl_results: result.listings.as_json, page: result.page, per_page: result.per_page,
                         has_more: result.has_more }, status: :ok
        rescue ExtractionCriteria::Invalid, MatchingCrawlResults::InvalidQuery => e
          render json: build_error_json(400, e.message, []), status: :bad_request
        end

        # 除外と取り消し。行は消さず excluded_at で表す
        def update
          crawl_result = ::ProductMonitoring::CrawlResult.find(params[:id])
          excluded = ActiveModel::Type::Boolean.new.cast(params.require(:excluded))
          crawl_result.update!(excluded_at: excluded ? Time.current : nil)
          render json: crawl_result.as_json, status: :ok
        end

        def destroy
          ::ProductMonitoring::CrawlResult.find(params[:id]).destroy!
          render json: {}, status: :ok
        end

        private

        def search_criteria
          filters = ExtractionCriteria::FIELDS.select { |key| params.key?(key) }.index_with { |key| params[key] }
          ExtractionCriteria.normalize(filters)
        end

        def search_query
          {
            sale_status: params[:sale_status].presence || "all",
            sort: params.fetch(:sort, "newest"),
            page: params.fetch(:page, 1)
          }
        end

        def filtered_results
          if ActiveModel::Type::Boolean.new.cast(params[:excluded])
            ::ProductMonitoring::CrawlResult.excluded
          else
            ::ProductMonitoring::CrawlResult.not_excluded.not_excluded_seller
          end
        end

        def preview_results(results)
          counts = results.group(:crawl_setting_id, :sold).count.map do |(id, sold), count|
            { crawl_setting_id: id, sold: sold, count: count }
          end
          ranked = results.select("product_monitoring_crawl_results.*, " \
                                  "ROW_NUMBER() OVER (PARTITION BY crawl_setting_id " \
                                  "ORDER BY id DESC) AS rank_position")
          preview = ::ProductMonitoring::CrawlResult.from(ranked,
                                                          :product_monitoring_crawl_results).where(rank_position: ..PREVIEW_COUNT)
          preview = preview.order(crawl_setting_id: :desc, id: :desc)
          { crawl_results: preview.as_json(except: :rank_position), counts: counts }
        end
      end
    end
  end
end
