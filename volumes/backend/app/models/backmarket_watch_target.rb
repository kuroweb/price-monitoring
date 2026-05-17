class BackmarketWatchTarget < ApplicationRecord
  ## associations ##
  has_many :backmarket_watch_results, dependent: :destroy

  ## validations ##
  validates :name, :url, presence: true

  ## scopes ##

  ## methods ##
end
