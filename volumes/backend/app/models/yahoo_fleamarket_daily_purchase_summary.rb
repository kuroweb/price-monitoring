class YahooFleamarketDailyPurchaseSummary < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##
  validates :purchase_count, :date, presence: true

  ## methods ##
end
