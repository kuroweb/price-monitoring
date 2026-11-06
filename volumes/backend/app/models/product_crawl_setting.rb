class ProductCrawlSetting < ApplicationRecord
  # DBの式による既定値は保存前のオブジェクトに反映されないため、モデルでも空配列にする
  %i[search_urls required_keywords exclude_keywords].each do |name|
    attribute name, default: -> { [] }
  end

  ## associations ##
  has_many :product_crawl_results, dependent: :destroy

  ## validations ##
  validates :name, presence: true

  ## scopes ##

  ## methods ##
end
