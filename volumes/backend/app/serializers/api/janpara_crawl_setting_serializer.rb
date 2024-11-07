module Api
  class JanparaCrawlSettingSerializer < BaseSerializer
    def initialize(janpara_crawl_setting)
      @janpara_crawl_setting = janpara_crawl_setting
    end

    private

    def json
      janpara_crawl_setting_json.merge(
        {
          janpara_crawl_setting_exclude_keywords: janpara_crawl_setting_exclude_keywords_json,
          janpara_crawl_setting_required_keywords: janpara_crawl_setting_required_keywords_json
        }
      )
    end

    def janpara_crawl_setting_json
      @janpara_crawl_setting.as_json
    end

    def janpara_crawl_setting_exclude_keywords_json
      @janpara_crawl_setting.janpara_crawl_setting_exclude_keywords.map(&:as_json)
    end

    def janpara_crawl_setting_required_keywords_json
      @janpara_crawl_setting.janpara_crawl_setting_required_keywords.map(&:as_json)
    end
  end
end
