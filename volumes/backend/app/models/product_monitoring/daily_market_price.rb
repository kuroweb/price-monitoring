module ProductMonitoring
  class DailyMarketPrice < ApplicationRecord
    ## associations ##
    belongs_to :monitor

    ## validations ##
    validates :date, presence: true

    ## scopes ##

    ## methods ##
  end
end
