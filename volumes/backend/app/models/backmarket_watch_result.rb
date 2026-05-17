class BackmarketWatchResult < ApplicationRecord
  ## associations ##
  belongs_to :backmarket_watch_target

  ## validations ##
  validates :name, :memory, :storage, :cpu, :stock_status, :crawled_at, presence: true
  validates :stock_status, inclusion: { in: %w[in_stock out_of_stock] }

  ## scopes ##

  ## methods ##
end
