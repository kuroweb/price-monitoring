module Products
  class Update
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

    def initialize(product:, params: {})
      @product = product
      @params = params
    end

    def call # rubocop:disable Metrics/AbcSize
      ApplicationRecord.transaction do
        product.update!(product_params)
        product.yahoo_auction_crawl_setting.update!(yahoo_auction_crawl_setting_params)
        product.mercari_crawl_setting.update!(mercari_crawl_setting_params)
        product.janpara_crawl_setting.update!(janpara_crawl_setting_params)
        product.iosys_crawl_setting.update!(iosys_crawl_setting_params)
        product.pc_koubou_crawl_setting.update!(pc_koubou_crawl_setting_params)
        product.used_sofmap_crawl_setting.update!(used_sofmap_crawl_setting_params)

        product
      end
    end

    private

    attr_reader :product, :params

    def product_params
      params.slice(*PRODUCT_ATTRIBUTES) || {}
    end

    def yahoo_auction_crawl_setting_params
      params[:yahoo_auction_crawl_setting]&.slice(*YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES) || {}
    end

    def mercari_crawl_setting_params
      params[:mercari_crawl_setting]&.slice(*MERCARI_CRAWL_SETTING_ATTRIBUTES) || {}
    end

    def janpara_crawl_setting_params
      params[:janpara_crawl_setting]&.slice(*JANPARA_CRAWL_SETTING_ATTRIBUTES) || {}
    end

    def iosys_crawl_setting_params
      params[:iosys_crawl_setting]&.slice(*IOSYS_CRAWL_SETTING_ATTRIBUTES) || {}
    end

    def pc_koubou_crawl_setting_params
      params[:pc_koubou_crawl_setting]&.slice(*PC_KOUBOU_CRAWL_SETTING_ATTRIBUTES) || {}
    end

    def used_sofmap_crawl_setting_params
      params[:used_sofmap_crawl_setting]&.slice(*USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES) || {}
    end
  end
end
