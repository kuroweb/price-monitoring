class IosysCrawlSettingRequiredKeyword < ApplicationRecord
  ## associations ##
  belongs_to :iosys_crawl_setting

  ## validations ##
  validates :keyword, presence: true

  ## scopes ##
  ## methods ##
end
