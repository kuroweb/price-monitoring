class UsedSofmapCrawlSettingSerializer < BaseSerializer
  delegate(*UsedSofmapCrawlSetting.column_names, to: :used_sofmap_crawl_setting)

  attr_reader :used_sofmap_crawl_setting

  def initialize(used_sofmap_crawl_setting)
    @used_sofmap_crawl_setting = used_sofmap_crawl_setting
  end

  private

  def attribute_names
    UsedSofmapCrawlSetting.column_names
  end
end
