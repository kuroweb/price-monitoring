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

    def call
      ApplicationRecord.transaction do
        update_product
        update_yahoo_auction_crawl_setting
        update_mercari_crawl_setting
        update_janpara_crawl_setting
        update_iosys_crawl_setting
        update_pc_koubou_crawl_setting
        update_used_sofmap_crawl_setting
        update_category_association

        product
      end
    end

    private

    attr_reader :product, :params

    def update_product
      attributes = params.slice(*PRODUCT_ATTRIBUTES) || {}
      product.update!(attributes)
    end

    def update_yahoo_auction_crawl_setting
      attributes = params[:yahoo_auction_crawl_setting]&.slice(*YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES) || {}
      product.yahoo_auction_crawl_setting.update!(attributes)
    end

    def update_mercari_crawl_setting
      attributes = params[:mercari_crawl_setting]&.slice(*MERCARI_CRAWL_SETTING_ATTRIBUTES) || {}
      product.mercari_crawl_setting.update!(attributes)
    end

    def update_janpara_crawl_setting
      attributes = params[:janpara_crawl_setting]&.slice(*JANPARA_CRAWL_SETTING_ATTRIBUTES) || {}
      product.janpara_crawl_setting.update!(attributes)
    end

    def update_iosys_crawl_setting
      attributes = params[:iosys_crawl_setting]&.slice(*IOSYS_CRAWL_SETTING_ATTRIBUTES) || {}
      product.iosys_crawl_setting.update!(attributes)
    end

    def update_pc_koubou_crawl_setting
      attributes = params[:pc_koubou_crawl_setting]&.slice(*PC_KOUBOU_CRAWL_SETTING_ATTRIBUTES) || {}
      product.pc_koubou_crawl_setting.update!(attributes)
    end

    def update_used_sofmap_crawl_setting
      attributes = params[:used_sofmap_crawl_setting]&.slice(*USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES) || {}
      product.used_sofmap_crawl_setting.update!(attributes)
    end

    def update_category_association
      category = Category.find(params[:category_id])
      product.category = category
    end
  end
end
