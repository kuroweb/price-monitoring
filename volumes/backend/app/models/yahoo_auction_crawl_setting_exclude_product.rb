class YahooAuctionCrawlSettingExcludeProduct < ApplicationRecord
  ## associations ##
  belongs_to :yahoo_auction_crawl_setting

  ## validations ##
  validates :external_id, presence: true

  ## scopes ##
  ## methods ##
end
