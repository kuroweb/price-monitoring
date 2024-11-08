module Api
  class MercariCrawlSettingRequiredKeywordSerializer < BaseSerializer
    def initialize(mercari_crawl_setting_required_keyword)
      @mercari_crawl_setting_required_keyword = mercari_crawl_setting_required_keyword
    end

    private

    def json
      @mercari_crawl_setting_required_keyword.as_json
    end
  end
end
