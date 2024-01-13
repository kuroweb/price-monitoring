class YahooAuctionCrawlSetting < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##
  validates :keyword, presence: true

  ## methods ##
  def crawlable_keyword
    keyword.gsub(" ", "+")
  end
end
