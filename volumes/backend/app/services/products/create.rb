module Products
  class Create # rubocop:disable Metrics/ClassLength
    PRODUCT_ATTRIBUTES = %i[name].freeze
    YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
    MERCARI_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
    JANPARA_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze
    IOSYS_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze
    PC_KOUBOU_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze
    USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @params = params
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      ApplicationRecord.transaction do
        product = create_product
        create_yahoo_auction_crawl_setting(product)
        create_yahoo_auction_crawl_setting_exclude_keywords(product)
        create_yahoo_auction_crawl_setting_required_keywords(product)
        create_mercari_crawl_setting(product)
        create_mercari_crawl_setting_exclude_keywords(product)
        create_mercari_crawl_setting_required_keywords(product)
        create_janpara_crawl_setting(product)
        create_janpara_crawl_setting_exclude_keywords(product)
        create_janpara_crawl_setting_required_keywords(product)
        create_iosys_crawl_setting(product)
        create_iosys_crawl_setting_exclude_keywords(product)
        create_iosys_crawl_setting_required_keywords(product)
        create_pc_koubou_crawl_setting(product)
        create_pc_koubou_crawl_setting_exclude_keywords(product)
        create_pc_koubou_crawl_setting_required_keywords(product)
        create_used_sofmap_crawl_setting(product)
        create_used_sofmap_crawl_setting_exclude_keywords(product)
        create_used_sofmap_crawl_setting_required_keywords(product)
        create_category_association(product)

        product
      end
    end

    private

    attr_reader :params

    def create_product
      attributes = params.slice(*PRODUCT_ATTRIBUTES) || {}
      Product.create!(attributes)
    end

    def create_yahoo_auction_crawl_setting(product)
      attributes = params[:yahoo_auction_crawl_setting]&.slice(*YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_yahoo_auction_crawl_setting!(attributes)
    end

    def create_yahoo_auction_crawl_setting_exclude_keywords(product)
      exclude_keywords_params =
        params.dig(:yahoo_auction_crawl_setting, :yahoo_auction_crawl_setting_exclude_keywords) || []

      exclude_keywords_params.each do |exclude_keyword_params|
        attributes = exclude_keyword_params&.slice(:keyword) || {}
        product.yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_keywords.create!(attributes)
      end
    end

    def create_yahoo_auction_crawl_setting_required_keywords(product)
      required_keywords_params =
        params.dig(:yahoo_auction_crawl_setting, :yahoo_auction_crawl_setting_required_keywords) || []

      required_keywords_params.each do |required_keyword_params|
        attributes = required_keyword_params&.slice(:keyword) || {}
        product.yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_required_keywords.create!(attributes)
      end
    end

    def create_mercari_crawl_setting(product)
      attributes = params[:mercari_crawl_setting]&.slice(*MERCARI_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_mercari_crawl_setting!(attributes)
    end

    def create_mercari_crawl_setting_exclude_keywords(product)
      exclude_keywords_params =
        params.dig(:mercari_crawl_setting, :mercari_crawl_setting_exclude_keywords) || []

      exclude_keywords_params.each do |exclude_keyword_params|
        attributes = exclude_keyword_params&.slice(:keyword) || {}
        product.mercari_crawl_setting.mercari_crawl_setting_exclude_keywords.create!(attributes)
      end
    end

    def create_mercari_crawl_setting_required_keywords(product)
      required_keywords_params =
        params.dig(:mercari_crawl_setting, :mercari_crawl_setting_required_keywords) || []

      required_keywords_params.each do |required_keyword_params|
        attributes = required_keyword_params&.slice(:keyword) || {}
        product.mercari_crawl_setting.mercari_crawl_setting_required_keywords.create!(attributes)
      end
    end

    def create_janpara_crawl_setting(product)
      attributes = params[:janpara_crawl_setting]&.slice(*JANPARA_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_janpara_crawl_setting!(attributes)
    end

    def create_janpara_crawl_setting_exclude_keywords(product)
      exclude_keywords_params =
        params.dig(:janpara_crawl_setting, :janpara_crawl_setting_exclude_keywords) || []

      exclude_keywords_params.each do |exclude_keyword_params|
        attributes = exclude_keyword_params&.slice(:keyword) || {}
        product.janpara_crawl_setting.janpara_crawl_setting_exclude_keywords.create!(attributes)
      end
    end

    def create_janpara_crawl_setting_required_keywords(product)
      required_keywords_params =
        params.dig(:janpara_crawl_setting, :janpara_crawl_setting_required_keywords) || []

      required_keywords_params.each do |required_keyword_params|
        attributes = required_keyword_params&.slice(:keyword) || {}
        product.janpara_crawl_setting.janpara_crawl_setting_required_keywords.create!(attributes)
      end
    end

    def create_iosys_crawl_setting(product)
      attributes = params[:iosys_crawl_setting]&.slice(*IOSYS_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_iosys_crawl_setting!(attributes)
    end

    def create_iosys_crawl_setting_exclude_keywords(product)
      exclude_keywords_params =
        params.dig(:iosys_crawl_setting, :iosys_crawl_setting_exclude_keywords) || []

      exclude_keywords_params.each do |exclude_keyword_params|
        attributes = exclude_keyword_params&.slice(:keyword) || {}
        product.iosys_crawl_setting.iosys_crawl_setting_exclude_keywords.create!(attributes)
      end
    end

    def create_iosys_crawl_setting_required_keywords(product)
      required_keywords_params =
        params.dig(:iosys_crawl_setting, :iosys_crawl_setting_required_keywords) || []

      required_keywords_params.each do |required_keyword_params|
        attributes = required_keyword_params&.slice(:keyword) || {}
        product.iosys_crawl_setting.iosys_crawl_setting_required_keywords.create!(attributes)
      end
    end

    def create_pc_koubou_crawl_setting(product)
      attributes = params[:pc_koubou_crawl_setting]&.slice(*PC_KOUBOU_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_pc_koubou_crawl_setting!(attributes)
    end

    def create_pc_koubou_crawl_setting_exclude_keywords(product)
      exclude_keywords_params =
        params.dig(:pc_koubou_crawl_setting, :pc_koubou_crawl_setting_exclude_keywords) || []

      exclude_keywords_params.each do |exclude_keyword_params|
        attributes = exclude_keyword_params&.slice(:keyword) || {}
        product.pc_koubou_crawl_setting.pc_koubou_crawl_setting_exclude_keywords.create!(attributes)
      end
    end

    def create_pc_koubou_crawl_setting_required_keywords(product)
      required_keywords_params =
        params.dig(:pc_koubou_crawl_setting, :pc_koubou_crawl_setting_required_keywords) || []

      required_keywords_params.each do |required_keyword_params|
        attributes = required_keyword_params&.slice(:keyword) || {}
        product.pc_koubou_crawl_setting.pc_koubou_crawl_setting_required_keywords.create!(attributes)
      end
    end

    def create_used_sofmap_crawl_setting(product)
      attributes = params[:used_sofmap_crawl_setting]&.slice(*USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_used_sofmap_crawl_setting!(attributes)
    end

    def create_used_sofmap_crawl_setting_exclude_keywords(product)
      exclude_keywords_params =
        params.dig(:used_sofmap_crawl_setting, :used_sofmap_crawl_setting_exclude_keywords) || []

      exclude_keywords_params.each do |exclude_keyword_params|
        attributes = exclude_keyword_params&.slice(:keyword) || {}
        product.used_sofmap_crawl_setting.used_sofmap_crawl_setting_exclude_keywords.create!(attributes)
      end
    end

    def create_used_sofmap_crawl_setting_required_keywords(product)
      required_keywords_params =
        params.dig(:used_sofmap_crawl_setting, :used_sofmap_crawl_setting_required_keywords) || []

      required_keywords_params.each do |required_keyword_params|
        attributes = required_keyword_params&.slice(:keyword) || {}
        product.used_sofmap_crawl_setting.used_sofmap_crawl_setting_required_keywords.create!(attributes)
      end
    end

    def create_category_association(product)
      category = Category.find(params[:category_id])
      product.category = category
    end
  end
end
