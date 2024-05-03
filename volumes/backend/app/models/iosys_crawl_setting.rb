class IosysCrawlSetting < ApplicationRecord
  ## associations ##
  belongs_to :product

  has_many :iosys_crawl_setting_exclude_keywords, dependent: :destroy
  has_many :iosys_crawl_setting_required_keywords, dependent: :destroy

  ## validations ##
  validates :keyword, presence: true

  ## methods ##
  def crawlable_keyword
    keyword.gsub(" ", "+")
  end
end
