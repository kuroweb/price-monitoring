module Api
  module V1
    module ProductCrawlSettings
      # 出品を除外出品IDに追加し、保存済みの商品計測結果から削除する
      class ExcludeExternalIdsController < Api::ApplicationController
        def create
          external_id = params.require(:external_id).to_s
          ProductCrawlSetting.transaction do
            product_crawl_setting.lock!
            exclude_external_ids = (product_crawl_setting.exclude_external_ids + [external_id]).uniq
            product_crawl_setting.update!(exclude_external_ids:)
            product_crawl_setting.product_crawl_results.where(external_id:).delete_all
          end
          render json: product_crawl_setting.as_json, status: :ok
        end

        private

        def product_crawl_setting
          @product_crawl_setting ||= ProductCrawlSetting.find(params[:product_crawl_setting_id])
        end
      end
    end
  end
end
