module Api
  module V1
    # 全商品計測設定の商品計測結果を横断して返す
    class ProductCrawlResultsController < Api::ApplicationController
      def index
        render json: {
          product_crawl_results: ProductCrawlResult.order(product_crawl_setting_id: :desc, id: :desc).as_json
        }, status: :ok
      end
    end
  end
end
