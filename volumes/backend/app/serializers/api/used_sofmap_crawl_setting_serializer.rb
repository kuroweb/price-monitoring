module Api
  class UsedSofmapCrawlSettingSerializer < BaseSerializer
    def initialize(used_sofmap_crawl_setting)
      @used_sofmap_crawl_setting = used_sofmap_crawl_setting
    end

    private

    def json
      used_sofmap_crawl_setting_json.merge(
        {
          used_sofmap_crawl_setting_exclude_keywords: used_sofmap_crawl_setting_exclude_keywords_json,
          used_sofmap_crawl_setting_required_keywords: used_sofmap_crawl_setting_required_keywords_json
        }
      )
    end

    def used_sofmap_crawl_setting_json
      @used_sofmap_crawl_setting.as_json
    end

    def used_sofmap_crawl_setting_exclude_keywords_json
      @used_sofmap_crawl_setting.used_sofmap_crawl_setting_exclude_keywords.map(&:as_json)
    end

    def used_sofmap_crawl_setting_required_keywords_json
      @used_sofmap_crawl_setting.used_sofmap_crawl_setting_required_keywords.map(&:as_json)
    end
  end
end
