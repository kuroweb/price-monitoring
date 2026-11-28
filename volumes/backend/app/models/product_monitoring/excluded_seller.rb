module ProductMonitoring
  class ExcludedSeller < ApplicationRecord
    # 一覧から出品者IDを読めるのはこの3サイトだけのため
    PLATFORMS = %w[mercari yahoo_fleamarket yahoo_auction].freeze

    validates :platform, :seller_id, presence: true
  end
end
