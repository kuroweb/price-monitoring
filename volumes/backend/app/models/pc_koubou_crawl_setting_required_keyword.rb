class PcKoubouCrawlSettingRequiredKeyword < ApplicationRecord
  ## associations ##
  belongs_to :pc_koubou_crawl_setting

  ## validations ##
  validates :keyword, presence: true

  ## scopes ##
  ## methods ##
end
