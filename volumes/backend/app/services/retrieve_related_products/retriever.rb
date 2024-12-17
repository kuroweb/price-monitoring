module RetrieveRelatedProducts
  class Retriever
    module ParamsType
      PLATFORM_MASK = %w[
        yahoo_auction.all
        yahoo_auction.published
        yahoo_auction.unpublished
        yahoo_auction.buyable
        yahoo_fleamarket.all
        yahoo_fleamarket.published
        yahoo_fleamarket.unpublished
        mercari.all
        mercari.published
        mercari.unpublished
        janpara.all
        iosys.all
        pc_koubou.all
        used_sofmap.all
      ].freeze

      SORT = %w[price bought_date created_at updated_at].freeze
      ORDER = %w[desc asc].freeze
    end

    module DefaultType
      SORT = "price".freeze
      ORDER = "asc".freeze
    end

    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @product_id = params[:product_id]
      @platform_mask = params[:platform_mask]
      @page = params[:page]
      @per = params[:per]
      @sort = params[:sort]
      @order = params[:order]
    end

    def call
      query_result = exec_query
      build_related_products(query_result)
    end

    private

    def exec_query
      sql = BuildSql.call(params: query_params)
      ActiveRecord::Base.connection.exec_query(sql)
    end

    def query_params
      {
        product_id:,
        platform_mask:,
        page:,
        per:,
        offset:,
        sort:,
        order:
      }
    end

    def product_id
      raise ArgumentError, "Invalid product_id" if @product_id.blank?

      @product_id
    end

    def platform_mask
      raise ArgumentError, "Invalid platform_mask" if @platform_mask.blank?

      masks = @platform_mask.split(",")
                            .select { |mask| ParamsType::PLATFORM_MASK.include?(mask) }
                            .uniq
      raise ArgumentError, "Invalid platform_mask" if masks.blank?

      masks.join(",")
    end

    def page
      @page.to_i.nonzero? || 1
    end

    def per
      @per.to_i.nonzero? || 10
    end

    def offset
      (page - 1) * per
    end

    def sort
      return DefaultType::SORT if @sort.blank?
      raise ArgumentError, "Invalid sort" unless ParamsType::SORT.include?(@sort)

      @sort
    end

    def order
      return DefaultType::ORDER if @order.blank?
      raise ArgumentError, "Invalid order" unless ParamsType::ORDER.include?(@order)

      @order
    end

    def build_related_products(query_result)
      related_product_list = query_result.map { |result| ::RelatedProduct.new(normalize_result(result)) }
      related_products = ::RelatedProducts.new(related_product_list)
      handle_errors(related_products)
      related_products
    end

    def normalize_result(result)
      result["published"] = result["published"] == 1
      result["bought_date"] = result["bought_date"]&.in_time_zone
      result["end_date"] = result["end_date"]&.in_time_zone
      result["created_at"] = result["created_at"]&.in_time_zone
      result["updated_at"] = result["updated_at"]&.in_time_zone
      result
    end

    def handle_errors(related_products)
      raise StandardError, related_products.errors.full_messages.join(", ") unless related_products.valid?
    end
  end
end
