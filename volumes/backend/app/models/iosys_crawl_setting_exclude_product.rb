class IosysCrawlSettingExcludeProduct < ApplicationRecord
  ## associations ##
  belongs_to :iosys_crawl_setting

  ## validations ##
  validates :external_id, presence: true

  ## scopes ##
  ## methods ##
end
