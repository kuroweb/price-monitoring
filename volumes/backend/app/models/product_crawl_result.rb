class ProductCrawlResult < ApplicationRecord
  ## associations ##
  belongs_to :product_crawl_setting

  ## validations ##
  validates :platform, :external_id, :name, :product_url, presence: true

  ## scopes ##
  scope :not_excluded, -> { where(excluded_at: nil) }
  scope :excluded, -> { where.not(excluded_at: nil) }

  ## methods ##
end
