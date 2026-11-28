module ProductMonitoring
  # 計測から除外する出品者。サイトと、そのサイトの出品者IDの完全一致で、収集結果を表示・通知・集計から外す
  class ExcludedSeller < ApplicationRecord
    # 一覧から出品者IDを読むサイト
    PLATFORMS = %w[mercari yahoo_fleamarket yahoo_auction].freeze

    ## validations ##
    validates :platform, :seller_id, presence: true
  end
end
