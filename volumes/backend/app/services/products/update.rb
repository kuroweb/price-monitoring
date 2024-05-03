module Products
  class Update
    PRODUCT_ATTRIBUTES = %i[name].freeze
    YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
    MERCARI_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
    JANPARA_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(product:, params: {})
      @product = product
      @params = params
    end

    def call
      ApplicationRecord.transaction do
        update_product
        update_yahoo_auction_crawl_setting
        update_mercari_crawl_setting
        update_janpara_crawl_setting

        ServiceResponse.success(payload: { product: })
      end
    rescue StandardError => e
      ServiceResponse.error(message: e.message)
    end

    private

    attr_reader :product, :params

    def update_product
      product.update(product_params)
    end

    def update_yahoo_auction_crawl_setting
      product.yahoo_auction_crawl_setting.update(yahoo_auction_crawl_setting_params)
    end

    def update_mercari_crawl_setting
      product.mercari_crawl_setting.update(mercari_crawl_setting_params)
    end

    def update_janpara_crawl_setting
      product.janpara_crawl_setting.update(janpara_crawl_setting_params)
    end

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
    end
  end
end
