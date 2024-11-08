module Api
  class UsedSofmapCrawlSettingRequiredKeywordSerializer < BaseSerializer
    def initialize(used_sofmap_crawl_setting_required_keyword)
      @used_sofmap_crawl_setting_required_keyword = used_sofmap_crawl_setting_required_keyword
    end

    private

    def json
      @used_sofmap_crawl_setting_required_keyword.as_json
    end
  end
end
