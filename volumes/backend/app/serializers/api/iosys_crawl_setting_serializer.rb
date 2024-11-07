module Api
  class IosysCrawlSettingSerializer < BaseSerializer
    def initialize(iosys_crawl_setting)
      @iosys_crawl_setting = iosys_crawl_setting
    end

    private

    def json
      iosys_crawl_setting_json.merge(
        {
          iosys_crawl_setting_exclude_keywords: iosys_crawl_setting_exclude_keywords_json,
          iosys_crawl_setting_required_keywords: iosys_crawl_setting_required_keywords_json
        }
      )
    end

    def iosys_crawl_setting_json
      @iosys_crawl_setting.as_json
    end

    def iosys_crawl_setting_exclude_keywords_json
      @iosys_crawl_setting.iosys_crawl_setting_exclude_keywords.map(&:as_json)
    end

    def iosys_crawl_setting_required_keywords_json
      @iosys_crawl_setting.iosys_crawl_setting_required_keywords.map(&:as_json)
    end
  end
end
