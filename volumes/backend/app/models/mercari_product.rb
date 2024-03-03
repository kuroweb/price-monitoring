class MercariProduct < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##

  ## scopes ##
  scope :published, -> { where(published: true) }
  scope :bought, -> { where.not(bought_date: nil) }

  ## methods ##
end
