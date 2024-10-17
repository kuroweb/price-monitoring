class IosysCrawlSettingSerializer < BaseSerializer
  delegate(*IosysCrawlSetting.column_names, to: :iosys_crawl_setting)

  attr_reader :iosys_crawl_setting

  def initialize(iosys_crawl_setting)
    @iosys_crawl_setting = iosys_crawl_setting
  end

  private

  def attribute_names
    IosysCrawlSetting.column_names
  end
end
