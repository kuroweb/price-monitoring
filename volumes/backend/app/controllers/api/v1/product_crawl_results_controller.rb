module Api
  module V1
    # 商品計測結果。product_crawl_setting_id でその設定の結果に絞り、excluded=true で除外した出品だけを返す
    class ProductCrawlResultsController < Api::ApplicationController
      def index
        product_crawl_results = ProductCrawlResult.order(product_crawl_setting_id: :desc, id: :desc)
        if params[:product_crawl_setting_id].present?
          product_crawl_results = product_crawl_results.where(product_crawl_setting_id: params[:product_crawl_setting_id])
        end
        product_crawl_results =
          ActiveModel::Type::Boolean.new.cast(params[:excluded]) ? product_crawl_results.excluded : product_crawl_results.not_excluded
        render json: { product_crawl_results: product_crawl_results.as_json }, status: :ok
      end

      # 除外と取り消し。行は消さず excluded_at で表す
      def update
        product_crawl_result = ProductCrawlResult.find(params[:id])
        excluded = ActiveModel::Type::Boolean.new.cast(params.require(:excluded))
        product_crawl_result.update!(excluded_at: excluded ? Time.current : nil)
        render json: product_crawl_result.as_json, status: :ok
      end
    end
  end
end
