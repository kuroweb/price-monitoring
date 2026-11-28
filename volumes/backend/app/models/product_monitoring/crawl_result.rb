module ProductMonitoring
  class CrawlResult < ApplicationRecord
    # price は int 列なので、これを超える表示価格は価格なしとして扱う
    MAX_PRICE = 2_147_483_647
    # サイトの一覧から読む出品者IDと、利用者が登録する出品者IDの形式。合わない値は出品者IDとして扱わない
    SELLER_ID_FORMAT = /\A[A-Za-z0-9_.-]{1,255}\z/

    ## associations ##
    belongs_to :crawl_setting

    ## validations ##
    validates :platform, :external_id, :name, :product_url, presence: true

    ## scopes ##
    scope :not_excluded, -> { where(excluded_at: nil) }
    scope :excluded, -> { where.not(excluded_at: nil) }
    # 除外する出品者の出品を除く。同じ出品の別の収集設定の行で分かった出品者IDも使い、出品者IDが不明な出品は残す
    scope :not_excluded_seller, lambda {
      where(<<~SQL.squish)
        NOT EXISTS (
          SELECT 1 FROM product_monitoring_crawl_results seller_rows
          INNER JOIN product_monitoring_excluded_sellers excluded_sellers
            ON excluded_sellers.platform = seller_rows.platform AND excluded_sellers.seller_id = seller_rows.seller_id
          WHERE seller_rows.platform = product_monitoring_crawl_results.platform
            AND seller_rows.external_id = product_monitoring_crawl_results.external_id
        )
      SQL
    }

    ## methods ##
  end
end
