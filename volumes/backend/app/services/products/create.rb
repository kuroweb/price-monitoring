module Products
  class Create
    PRODUCT_ATTRIBUTES = %i[name].freeze
    YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
    MERCARI_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
    JANPARA_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @params = params
    end

    def call
      ApplicationRecord.transaction do
        product = Product.create!(product_params)
        product.create_yahoo_auction_crawl_setting!(yahoo_auction_crawl_setting_params)
        product.create_mercari_crawl_setting!(mercari_crawl_setting_params)
        product.create_janpara_crawl_setting!(janpara_crawl_setting_params)

        ServiceResponse.success(payload: { product: })
      end
    rescue StandardError => e
      ServiceResponse.error(message: e.message)
    end

    private

    attr_reader :params

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
      params[:janpara_crawl_setting]&.slice(*MERCARI_CRAWL_SETTING_ATTRIBUTES) || {}
    end
  end
end
