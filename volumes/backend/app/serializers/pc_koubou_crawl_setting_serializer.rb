class PcKoubouCrawlSettingSerializer < BaseSerializer
  delegate(*PcKoubouCrawlSetting.column_names, to: :pc_koubou_crawl_setting)

  attr_reader :pc_koubou_crawl_setting

  def initialize(pc_koubou_crawl_setting)
    @pc_koubou_crawl_setting = pc_koubou_crawl_setting
  end

  private

  def attribute_names
    PcKoubouCrawlSetting.column_names
  end
end
