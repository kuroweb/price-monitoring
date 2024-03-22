class MercariDailyPurchaseSummary < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##
  validates :purchase_count, presence: true
  validates :date, presence: true

  ## methods ##
end
