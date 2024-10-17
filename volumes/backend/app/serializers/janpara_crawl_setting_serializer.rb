class JanparaCrawlSettingSerializer < BaseSerializer
  delegate(*JanparaCrawlSetting.column_names, to: :janpara_crawl_setting)

  attr_reader :janpara_crawl_setting

  def initialize(janpara_crawl_setting)
    @janpara_crawl_setting = janpara_crawl_setting
  end

  private

  def attribute_names
    JanparaCrawlSetting.column_names
  end
end
