module ProductMonitoring
  class DailyMarketPrice < ApplicationRecord
    belongs_to :monitor

    validates :date, presence: true
  end
end
