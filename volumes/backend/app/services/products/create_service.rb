module Products
  class CreateService
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

        ServiceResponse.success(payload: { product: })
      end
    rescue StandardError => e
      ServiceResponse.error(message: e.message)
    end

    private

    attr_reader :params

    def product_params
      { name: params[:name] }
    end

    def yahoo_auction_crawl_setting_params
      {
        keyword: params.dig(:yahoo_auction_crawl_setting, :keyword),
        category_id: params.dig(:yahoo_auction_crawl_setting, :category_id),
        min_price: params.dig(:yahoo_auction_crawl_setting, :min_price),
        max_price: params.dig(:yahoo_auction_crawl_setting, :max_price),
        enabled: params.dig(:yahoo_auction_crawl_setting, :enabled)
      }
    end
  end
end
