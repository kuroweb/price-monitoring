module Api
  class UsedSofmapCrawlSettingExcludeKeywordSerializer < BaseSerializer
    def initialize(used_sofmap_crawl_setting_exclude_keyword)
      @used_sofmap_crawl_setting_exclude_keyword = used_sofmap_crawl_setting_exclude_keyword
    end

    private

    def json
      @used_sofmap_crawl_setting_exclude_keyword.as_json
    end
  end
end
