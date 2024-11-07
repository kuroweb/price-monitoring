module Api
  class MercariCrawlSettingSerializer < BaseSerializer
    def initialize(mercari_crawl_setting)
      @mercari_crawl_setting = mercari_crawl_setting
    end

    private

    def json
      mercari_crawl_setting_json.merge(
        {
          mercari_crawl_setting_exclude_keywords: mercari_crawl_setting_exclude_keywords_json,
          mercari_crawl_setting_required_keywords: mercari_crawl_setting_required_keywords_json
        }
      )
    end

    def mercari_crawl_setting_json
      @mercari_crawl_setting.as_json
    end

    def mercari_crawl_setting_exclude_keywords_json
      @mercari_crawl_setting.mercari_crawl_setting_exclude_keywords.map(&:as_json)
    end

    def mercari_crawl_setting_required_keywords_json
      @mercari_crawl_setting.mercari_crawl_setting_required_keywords.map(&:as_json)
    end
  end
end
