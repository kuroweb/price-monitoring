module Api
  class IosysCrawlSettingRequiredKeywordSerializer < BaseSerializer
    def initialize(iosys_crawl_setting_required_keyword)
      @iosys_crawl_setting_required_keyword = iosys_crawl_setting_required_keyword
    end

    private

    def json
      @iosys_crawl_setting_required_keyword.as_json
    end
  end
end
