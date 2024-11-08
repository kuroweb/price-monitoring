module Api
  class PcKoubouCrawlSettingSerializer < BaseSerializer
    def initialize(pc_koubou_crawl_setting)
      @pc_koubou_crawl_setting = pc_koubou_crawl_setting
    end

    private

    def json
      pc_koubou_crawl_setting_json.merge(
        {
          pc_koubou_crawl_setting_exclude_keywords: pc_koubou_crawl_setting_exclude_keywords_json,
          pc_koubou_crawl_setting_required_keywords: pc_koubou_crawl_setting_required_keywords_json
        }
      )
    end

    def pc_koubou_crawl_setting_json
      @pc_koubou_crawl_setting.as_json
    end

    def pc_koubou_crawl_setting_exclude_keywords_json
      @pc_koubou_crawl_setting.pc_koubou_crawl_setting_exclude_keywords.map do |p|
        PcKoubouCrawlSettingExcludeKeywordSerializer.new(p).render_json
      end
    end

    def pc_koubou_crawl_setting_required_keywords_json
      @pc_koubou_crawl_setting.pc_koubou_crawl_setting_required_keywords.map do |p|
        PcKoubouCrawlSettingRequiredKeywordSerializer.new(p).render_json
      end
    end
  end
end
