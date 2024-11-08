module Api
  class PcKoubouCrawlSettingRequiredKeywordSerializer < BaseSerializer
    def initialize(pc_koubou_crawl_setting_required_keyword)
      @pc_koubou_crawl_setting_required_keyword = pc_koubou_crawl_setting_required_keyword
    end

    private

    def json
      @pc_koubou_crawl_setting_required_keyword.as_json
    end
  end
end
