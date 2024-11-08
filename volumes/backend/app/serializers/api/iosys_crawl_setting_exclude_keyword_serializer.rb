module Api
  class IosysCrawlSettingExcludeKeywordSerializer < BaseSerializer
    def initialize(iosys_crawl_setting_exclude_keyword)
      @iosys_crawl_setting_exclude_keyword = iosys_crawl_setting_exclude_keyword
    end

    private

    def json
      @iosys_crawl_setting_exclude_keyword.as_json
    end
  end
end
