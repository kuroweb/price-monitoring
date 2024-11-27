module Products
  module Creator
    class CreateUsedSofmapCrawlSettings
      USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
      USED_SOFMAP_CRAWL_SETTING_EXCLUDE_KEYWORD_ATTRIBUTES = %i[keyword].freeze
      USED_SOFMAP_CRAWL_SETTING_REQUIRED_KEYWORD_ATTRIBUTES = %i[keyword].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(product:, params: {})
        @product = product
        @params = params
      end

      def call
        ApplicationRecord.transaction do
          create_used_sofmap_crawl_setting
          create_used_sofmap_crawl_setting_exclude_keywords
          create_used_sofmap_crawl_setting_required_keywords
        end
      end

      private

      attr_reader :product, :params

      def create_used_sofmap_crawl_setting
        attributes = params[:used_sofmap_crawl_setting]&.slice(*USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES) || {}
        product.create_used_sofmap_crawl_setting!(attributes)
      end

      def create_used_sofmap_crawl_setting_exclude_keywords
        exclude_keywords_params.each do |p|
          attributes = p&.slice(*USED_SOFMAP_CRAWL_SETTING_EXCLUDE_KEYWORD_ATTRIBUTES) || {}
          exclude_keywords.create!(attributes)
        end
      end

      def create_used_sofmap_crawl_setting_required_keywords
        required_keywords_params.each do |p|
          attributes = p&.slice(*USED_SOFMAP_CRAWL_SETTING_REQUIRED_KEYWORD_ATTRIBUTES) || {}
          required_keywords.create!(attributes)
        end
      end

      def exclude_keywords_params
        params.dig(:used_sofmap_crawl_setting, :used_sofmap_crawl_setting_exclude_keywords) || []
      end

      def required_keywords_params
        params.dig(:used_sofmap_crawl_setting, :used_sofmap_crawl_setting_required_keywords) || []
      end

      def exclude_keywords
        @exclude_keywords ||= product.used_sofmap_crawl_setting.used_sofmap_crawl_setting_exclude_keywords
      end

      def required_keywords
        @required_keywords ||= product.used_sofmap_crawl_setting.used_sofmap_crawl_setting_required_keywords
      end
    end
  end
end
