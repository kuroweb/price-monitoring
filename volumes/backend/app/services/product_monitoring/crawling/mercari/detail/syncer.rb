module ProductMonitoring
  module Crawling
    module Mercari
      module Detail
        # 詳細ページで確かめた販売状態を、メルカリの同じ出品IDの行すべて（設定ごとにある）に反映する
        class Syncer
          def self.call(...)
            new(...).call
          end

          def initialize(external_id:)
            @external_id = external_id
          end

          def call
            return unless results.exists?

            detail = Crawler.call(external_id:)
            return results.delete_all if detail[:deleted]
            # 販売状態を判定できない出品は、確認を後回しにするため更新日時だけ進める
            return results.update_all(updated_at: Time.current) unless detail.key?(:sold) # rubocop:disable Rails/SkipsModelValidations

            update_sold(detail)
          end

          private

          attr_reader :external_id

          def update_sold(detail)
            results.update_all(sold: detail[:sold], updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
            update_bought_date(detail[:bought_date]) if detail[:bought_date]
          end

          def results
            ProductCrawlResult.where(platform: Listing::SearchUrl::PLATFORM, external_id:)
          end

          # 並行処理で記録された売れた日は上書きしない
          def update_bought_date(bought_date)
            results.where(bought_date: nil).update_all(bought_date:) # rubocop:disable Rails/SkipsModelValidations
          end
        end
      end
    end
  end
end
