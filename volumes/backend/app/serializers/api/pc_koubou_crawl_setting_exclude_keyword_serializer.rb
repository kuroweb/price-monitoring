module Api
  class PcKoubouCrawlSettingExcludeKeywordSerializer < BaseSerializer
    def initialize(pc_koubou_crawl_setting_exclude_keyword)
      @pc_koubou_crawl_setting_exclude_keyword = pc_koubou_crawl_setting_exclude_keyword
    end

    private

    def json
      @pc_koubou_crawl_setting_exclude_keyword.as_json
    end
  end
end
