module Api
  class MercariCrawlSettingExcludeKeywordSerializer < BaseSerializer
    def initialize(mercari_crawl_setting_exclude_keyword)
      @mercari_crawl_setting_exclude_keyword = mercari_crawl_setting_exclude_keyword
    end

    private

    def json
      @mercari_crawl_setting_exclude_keyword.as_json
    end
  end
end
