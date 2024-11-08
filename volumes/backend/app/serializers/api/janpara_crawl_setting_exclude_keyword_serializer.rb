module Api
  class JanparaCrawlSettingExcludeKeywordSerializer < BaseSerializer
    def initialize(janpara_crawl_setting_exclude_keyword)
      @janpara_crawl_setting_exclude_keyword = janpara_crawl_setting_exclude_keyword
    end

    private

    def json
      @janpara_crawl_setting_exclude_keyword.as_json
    end
  end
end
