class MercariCrawlSettingSerializer < BaseSerializer
  delegate(*MercariCrawlSetting.column_names, to: :mercari_crawl_setting)

  attr_reader :mercari_crawl_setting

  def initialize(mercari_crawl_setting)
    @mercari_crawl_setting = mercari_crawl_setting
  end

  private

  def attribute_names
    MercariCrawlSetting.column_names
  end
end
