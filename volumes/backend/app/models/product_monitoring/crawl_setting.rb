module ProductMonitoring
  class CrawlSetting < ApplicationRecord
    # DBの式による既定値は保存前のオブジェクトに反映されないため、モデルでも空配列にする
    %i[platforms search_urls required_keywords negative_keywords].each do |name|
      attribute name, default: -> { [] }
    end

    has_many :crawl_results, dependent: :destroy

    validates :name, presence: true
  end
end
