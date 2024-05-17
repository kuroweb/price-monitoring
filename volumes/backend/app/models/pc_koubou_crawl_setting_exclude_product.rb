class PcKoubouCrawlSettingExcludeProduct < ApplicationRecord
  ## associations ##
  belongs_to :pc_koubou_crawl_setting

  ## validations ##
  validates :external_id, presence: true

  ## scopes ##
  ## methods ##
end
