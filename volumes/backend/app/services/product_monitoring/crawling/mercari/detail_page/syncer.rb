module ProductMonitoring
  module Crawling
    module Mercari
      module DetailPage
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
            if detail[:sold_at]
              results.update_all(sold: detail[:sold], updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
              update_sold_at(detail[:sold_at])
            elsif detail[:sold]
              results.update_all(sold: true, recency_at: nil, updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
            else
              results.update_all(["sold = ?, recency_at = created_at, updated_at = ?", detail[:sold], Time.current]) # rubocop:disable Rails/SkipsModelValidations
            end
          end

          def results
            ProductMonitoring::CrawlResult.where(platform: ListPage::SearchUrl::PLATFORM, external_id:)
          end

          # 並行処理で記録された売れた日は上書きしない
          def update_sold_at(sold_at)
            results.where(sold_at: nil).update_all(sold_at:) # rubocop:disable Rails/SkipsModelValidations
            results.update_all("recency_at = sold_at") # rubocop:disable Rails/SkipsModelValidations
          end
        end
      end
    end
  end
end
