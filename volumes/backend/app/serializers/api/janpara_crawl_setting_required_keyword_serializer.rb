module Api
  class JanparaCrawlSettingRequiredKeywordSerializer < BaseSerializer
    def initialize(janpara_crawl_setting_required_keyword)
      @janpara_crawl_setting_required_keyword = janpara_crawl_setting_required_keyword
    end

    private

    def json
      @janpara_crawl_setting_required_keyword.as_json
    end
  end
end
