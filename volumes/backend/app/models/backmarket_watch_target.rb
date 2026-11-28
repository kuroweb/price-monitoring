class BackmarketWatchTarget < ApplicationRecord
  has_many :backmarket_watch_results, dependent: :destroy

  validates :name, :url, presence: true
end
