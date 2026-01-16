module Api
  class ProductPriceListSerializer
    def initialize(params)
      @params = params.as_json.symbolize_keys
    end

    def as_json(_opts = {})
      target_products.map do |product|
        product.as_json.merge("related_products" => related_products(product.id))
      end
    end

    private

    attr_reader :params

    def related_products(product_id)
      RetrieveRelatedProducts::Retriever.call(params: retrieve_params(product_id))
                                        .products.map(&:attributes)
    end

    def retrieve_params(product_id)
      {
        product_id:,
        platform_mask: params[:platform_mask],
        sort: params[:sort],
        order: params[:order],
        page: 1,
        per: params[:price_display_limit]
      }
    end

    def target_products
      products = Product.all
      products = filter_by_category(products) if params[:category_id].present?
      products
    end

    def filter_by_category(products)
      products
        .joins(:product_category_map)
        .where(product_category_maps: { category_id: category_ids })
    end

    def category_ids
      category = Category.find_by(id: params[:category_id])
      return [] if category.blank?

      [category.id] + category.descendant_ids
    end
  end
end
