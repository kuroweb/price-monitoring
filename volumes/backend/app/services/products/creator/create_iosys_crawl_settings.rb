module Products
  module Creator
    class CreateIosysCrawlSettings
      IOSYS_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
      IOSYS_CRAWL_SETTING_EXCLUDE_KEYWORD_ATTRIBUTES = %i[keyword].freeze
      IOSYS_CRAWL_SETTING_REQUIRED_KEYWORD_ATTRIBUTES = %i[keyword].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(product:, params: {})
        @product = product
        @params = params
      end

      def call
        ApplicationRecord.transaction do
          create_iosys_crawl_setting
          create_iosys_crawl_setting_exclude_keywords
          create_iosys_crawl_setting_required_keywords
        end
      end

      private

      attr_reader :product, :params

      def create_iosys_crawl_setting
        attributes = params[:iosys_crawl_setting]&.slice(*IOSYS_CRAWL_SETTING_ATTRIBUTES) || {}
        product.create_iosys_crawl_setting!(attributes)
      end

      def create_iosys_crawl_setting_exclude_keywords
        exclude_keywords_params.each do |p|
          attributes = p&.slice(*IOSYS_CRAWL_SETTING_EXCLUDE_KEYWORD_ATTRIBUTES) || {}
          exclude_keywords.create!(attributes)
        end
      end

      def create_iosys_crawl_setting_required_keywords
        required_keywords_params.each do |p|
          attributes = p&.slice(*IOSYS_CRAWL_SETTING_REQUIRED_KEYWORD_ATTRIBUTES) || {}
          required_keywords.create!(attributes)
        end
      end

      def exclude_keywords_params
        params.dig(:iosys_crawl_setting, :iosys_crawl_setting_exclude_keywords) || []
      end

      def required_keywords_params
        params.dig(:iosys_crawl_setting, :iosys_crawl_setting_required_keywords) || []
      end

      def exclude_keywords
        @exclude_keywords ||= product.iosys_crawl_setting.iosys_crawl_setting_exclude_keywords
      end

      def required_keywords
        @required_keywords ||= product.iosys_crawl_setting.iosys_crawl_setting_required_keywords
      end
    end
  end
end
