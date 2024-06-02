class UsedSofmapCrawlSettingExcludeProduct < ApplicationRecord
  ## associations ##
  belongs_to :used_sofmap_crawl_setting

  ## validations ##
  validates :external_id, presence: true

  ## scopes ##

  ## methods ##
end
