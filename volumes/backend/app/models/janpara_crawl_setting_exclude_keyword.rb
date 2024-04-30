class JanparaCrawlSettingExcludeKeyword < ApplicationRecord
  ## associations ##
  belongs_to :janpara_crawl_setting

  ## validations ##
  validates :keyword, presence: true

  ## scopes ##
  ## methods ##
end
