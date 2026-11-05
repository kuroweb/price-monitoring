class ProductCrawlResult < ApplicationRecord
  ## associations ##
  belongs_to :product_crawl_setting

  ## validations ##
  validates :platform, :external_id, :name, :product_url, presence: true

  ## scopes ##

  ## methods ##
end
