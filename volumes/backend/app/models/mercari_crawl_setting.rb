class MercariCrawlSetting < ApplicationRecord
  ## associations ##
  belongs_to :product

  has_many :mercari_crawl_setting_exclude_keywords

  ## validations ##
  validates :keyword, presence: true

  ## methods ##
  def crawlable_keyword
    keyword.gsub(" ", "+")
  end
end
