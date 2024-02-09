class YahooAuctionCrawlSetting < ApplicationRecord
  ## associations ##
  belongs_to :product

  has_many :yahoo_auction_crawl_setting_exclude_conditions

  ## validations ##
  validates :keyword, presence: true

  ## methods ##
  def crawlable_keyword
    keyword.gsub(" ", "+")
  end
end
