module ProductMonitoring
  class CrawlResult < ApplicationRecord
    # price は int 列なので、これを超える表示価格は価格なしとして扱う
    MAX_PRICE = 2_147_483_647

    ## associations ##
    belongs_to :crawl_setting

    ## validations ##
    validates :platform, :external_id, :name, :product_url, presence: true

    ## scopes ##
    scope :not_excluded, -> { where(excluded_at: nil) }
    scope :excluded, -> { where.not(excluded_at: nil) }

    ## methods ##
  end
end
