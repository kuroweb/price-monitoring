module Crawl
  module Mercari
    module SyncProducts
      class Syncer
        def self.call(...)
          new(...).call
        end

        def initialize(product:)
          @product = product
        end

        def call
          return unless mercari_crawl_setting.enabled?

          MercariProduct.transaction do
            upsert
            inspect
            enqueue_for_existence
            enqueue_for_bought_date
          end
        end

        private

        attr_reader :product

        # 計測結果を保存する
        def upsert
          upsert_params = crawl_results.results.map do |result|
            result.attributes.merge("product_id" => product.id)
          end

          MercariProduct.upsert_all(upsert_params, record_timestamps: true)
        end

        # 計測設定とマッチしないレコードを削除する
        def inspect
          Crawl::Mercari::Inspect.call(product:)
        end

        # 今回の計測結果に含まれなかった過去の計測結果を個別同期する
        def enqueue_for_existence
          job_params =
            MercariProduct
            .where(product_id: product.id, published: true)
            .where.not(mercari_id: crawl_results.results.map(&:mercari_id))
            .map { |mercari_product| [mercari_product.id] }

          Crawl::Mercari::SyncProduct::SyncJob.perform_bulk(job_params)
        end

        # 計測結果の売り切れ日時を個別同期する
        def enqueue_for_bought_date
          job_params =
            MercariProduct
            .where(product_id: product.id, published: false, bought_date: nil)
            .map { |mercari_product| [mercari_product.id] }

          Crawl::Mercari::SyncProduct::SyncJob.perform_bulk(job_params)
        end

        def mercari_crawl_setting
          @mercari_crawl_setting ||= product.mercari_crawl_setting
        end

        def crawl_results
          @crawl_results ||= Crawler.new(product:).execute
        end
      end
    end
  end
end
