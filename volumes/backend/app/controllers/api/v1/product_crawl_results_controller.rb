module Api
  module V1
    # 商品計測結果。product_crawl_setting_id でその設定の結果に絞り、excluded=true で除外した出品だけを返す
    class ProductCrawlResultsController < Api::ApplicationController
      PREVIEW_COUNT = 8

      def index
        product_crawl_results = filtered_results
        if params[:product_crawl_setting_id].present?
          results = product_crawl_results.where(product_crawl_setting_id: params[:product_crawl_setting_id])
          render json: { product_crawl_results: results.order(id: :desc).as_json }, status: :ok
        else
          render json: preview_results(product_crawl_results), status: :ok
        end
      end

      # 除外と取り消し。行は消さず excluded_at で表す
      def update
        product_crawl_result = ProductCrawlResult.find(params[:id])
        excluded = ActiveModel::Type::Boolean.new.cast(params.require(:excluded))
        product_crawl_result.update!(excluded_at: excluded ? Time.current : nil)
        render json: product_crawl_result.as_json, status: :ok
      end

      private

      def filtered_results
        if ActiveModel::Type::Boolean.new.cast(params[:excluded])
          ProductCrawlResult.excluded
        else
          ProductCrawlResult.not_excluded
        end
      end

      def preview_results(results)
        counts = results.group(:product_crawl_setting_id, :sold).count.map do |(id, sold), count|
          { product_crawl_setting_id: id, sold: sold, count: count }
        end
        ranked = results.select("product_crawl_results.*, " \
                                "ROW_NUMBER() OVER (PARTITION BY product_crawl_setting_id " \
                                "ORDER BY id DESC) AS rank_position")
        preview = ProductCrawlResult.from(ranked, :product_crawl_results).where(rank_position: ..PREVIEW_COUNT)
        preview = preview.order(product_crawl_setting_id: :desc, id: :desc)
        { product_crawl_results: preview.as_json(except: :rank_position), counts: counts }
      end
    end
  end
end
