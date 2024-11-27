module Products
  module Creator
    class CreateMercariCrawlSettings
      MERCARI_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
      MERCARI_CRAWL_SETTING_EXCLUDE_KEYWORD_ATTRIBUTES = %i[keyword].freeze
      MERCARI_CRAWL_SETTING_REQUIRED_KEYWORD_ATTRIBUTES = %i[keyword].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(product:, params: {})
        @product = product
        @params = params
      end

      def call
        ApplicationRecord.transaction do
          create_mercari_crawl_setting
          create_mercari_crawl_setting_exclude_keywords
          create_mercari_crawl_setting_required_keywords
        end
      end

      private

      attr_reader :product, :params

      def create_mercari_crawl_setting
        attributes = params[:mercari_crawl_setting]&.slice(*MERCARI_CRAWL_SETTING_ATTRIBUTES) || {}
        product.create_mercari_crawl_setting!(attributes)
      end

      def create_mercari_crawl_setting_exclude_keywords
        return unless exist_exclude_keyword_params?

        exclude_keywords.delete_all
        exclude_keywords_params.each do |p|
          attributes = p&.slice(*MERCARI_CRAWL_SETTING_EXCLUDE_KEYWORD_ATTRIBUTES) || {}
          exclude_keywords.create!(attributes)
        end
      end

      def create_mercari_crawl_setting_required_keywords
        return unless exist_required_keyword_params?

        required_keywords.delete_all
        required_keywords_params.each do |p|
          attributes = p&.slice(*MERCARI_CRAWL_SETTING_REQUIRED_KEYWORD_ATTRIBUTES) || {}
          required_keywords.create!(attributes)
        end
      end

      def exist_exclude_keyword_params?
        params[:mercari_crawl_setting]&.key?(:mercari_crawl_setting_exclude_keywords)
      end

      def exist_required_keyword_params?
        params[:mercari_crawl_setting]&.key?(:mercari_crawl_setting_required_keywords)
      end

      def exclude_keywords_params
        params.dig(:mercari_crawl_setting, :mercari_crawl_setting_exclude_keywords) || []
      end

      def required_keywords_params
        params.dig(:mercari_crawl_setting, :mercari_crawl_setting_required_keywords) || []
      end

      def exclude_keywords
        @exclude_keywords ||= product.mercari_crawl_setting.mercari_crawl_setting_exclude_keywords
      end

      def required_keywords
        @required_keywords ||= product.mercari_crawl_setting.mercari_crawl_setting_required_keywords
      end
    end
  end
end
