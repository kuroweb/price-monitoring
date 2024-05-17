class MercariCrawlSettingExcludeProduct < ApplicationRecord
  ## associations ##
  belongs_to :mercari_crawl_setting

  ## validations ##
  validates :external_id, presence: true

  ## scopes ##
  ## methods ##
end
