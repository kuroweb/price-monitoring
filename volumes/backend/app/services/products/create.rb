module Products
  class Create
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

    def call
      ApplicationRecord.transaction do
        product = create_product
        create_yahoo_auction_crawl_setting(product)
        create_mercari_crawl_setting(product)
        create_janpara_crawl_setting(product)
        create_iosys_crawl_setting(product)
        create_pc_koubou_crawl_setting(product)
        create_used_sofmap_crawl_setting(product)
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

    def create_mercari_crawl_setting(product)
      attributes = params[:mercari_crawl_setting]&.slice(*MERCARI_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_mercari_crawl_setting!(attributes)
    end

    def create_janpara_crawl_setting(product)
      attributes = params[:janpara_crawl_setting]&.slice(*JANPARA_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_janpara_crawl_setting!(attributes)
    end

    def create_iosys_crawl_setting(product)
      attributes = params[:iosys_crawl_setting]&.slice(*IOSYS_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_iosys_crawl_setting!(attributes)
    end

    def create_pc_koubou_crawl_setting(product)
      attributes = params[:pc_koubou_crawl_setting]&.slice(*PC_KOUBOU_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_pc_koubou_crawl_setting!(attributes)
    end

    def create_used_sofmap_crawl_setting(product)
      attributes = params[:used_sofmap_crawl_setting]&.slice(*USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES) || {}
      product.create_used_sofmap_crawl_setting!(attributes)
    end

    def create_category_association(product)
      category = Category.find(params[:category_id])
      product.category = category
    end
  end
end
