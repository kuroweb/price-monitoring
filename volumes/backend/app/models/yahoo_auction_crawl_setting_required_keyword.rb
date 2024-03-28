class YahooAuctionCrawlSettingRequiredKeyword < ApplicationRecord
  ## associations ##
  belongs_to :yahoo_auction_crawl_setting

  ## validations ##
  validates :keyword, presence: true

  ## scopes ##
  ## methods ##
end
