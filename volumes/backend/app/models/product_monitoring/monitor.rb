module ProductMonitoring
  class Monitor < ApplicationRecord
    has_many :daily_market_prices, dependent: :destroy
    %i[required_keywords negative_keywords].each do |name|
      attribute name, default: -> { [] }
    end

    validates :name, presence: true
  end
end
