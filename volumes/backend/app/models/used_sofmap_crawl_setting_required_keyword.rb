class UsedSofmapCrawlSettingRequiredKeyword < ApplicationRecord
  ## associations ##
  belongs_to :used_sofmap_crawl_setting

  ## validations ##
  validates :keyword, presence: true

  ## scopes ##

  ## methods ##
end
