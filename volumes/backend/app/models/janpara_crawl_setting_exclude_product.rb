class JanparaCrawlSettingExcludeProduct < ApplicationRecord
  ## associations ##
  belongs_to :janpara_crawl_setting

  ## validations ##
  validates :external_id, presence: true

  ## scopes ##
  ## methods ##
end
