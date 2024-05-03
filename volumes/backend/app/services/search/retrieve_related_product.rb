# Productに紐づく関連商品を取得する
# 一覧表示用の検索クラス
module Search
  class RetrieveRelatedProduct
    PLATFORM_MASK_TYPES = %w[yahoo_auction yahoo_fleamarket mercari janpara iosys].freeze
    SORT_TYPES = %w[bought_date created_at updated_at].freeze
    ORDER_TYPES = %w[desc asc].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(params: {}) # rubocop:disable Metrics/AbcSize
      @product_id = params[:product_id]
      @platform_mask = params[:platform_mask]
      @published = params[:published]
      @yahoo_auction_buyable = params[:yahoo_auction_buyable]
      @page = params[:page].to_i.nonzero? || 1
      @per = params[:per].to_i.nonzero? || 10
      @offset = (page - 1) * per
      @sort = params[:sort] || "updated_at"
      @order = params[:order] || "desc"
    end

    def call
      records = exec_query
      related_products = RelatedProducts.new(records.map { |record| RelatedProduct.new(normalize(record)) })

      raise StandardError, related_products.errors unless related_products.valid?

      related_products
    end

    private

    attr_reader :product_id, :published, :page, :per, :offset, :sort, :order, :platform_mask, :yahoo_auction_buyable

    def exec_query
      ActiveRecord::Base.connection.exec_query(sql)
    end

    def sql
      <<~SQL.squish
        #{build_platform_sql}
        ORDER BY
          #{build_order_sql}
        LIMIT
          #{per} OFFSET #{offset}
      SQL
    end

    def build_platform_sql
      masks = platform_mask.split(",").select { |mask| PLATFORM_MASK_TYPES.include?(mask) }
      masks.map { |mask| build_sql_for(mask) }.join(" UNION ")
    end

    def build_sql_for(platform)
      condition = base_condition(platform)
      condition = published_condition(platform, condition)
      condition = yahoo_auction_buyable_condition(platform, condition)
      condition.to_sql
    end

    def base_condition(platform)
      product.send("#{platform}_products")
             .select(common_columns(platform) + additional_columns(platform))
    end

    def common_columns(platform)
      [
        "'#{platform}' AS platform", "#{platform}_id AS external_id",
        "product_id", "name", "price", "thumbnail_url", "created_at", "updated_at"
      ]
    end

    def additional_columns(platform)
      columns = []

      columns <<
        if platform == "yahoo_auction"
          %w[buyout_price end_date]
        else
          ["NULL AS buyout_price", "NULL AS end_date"]
        end

      columns <<
        if shop_platform?(platform)
          ["TRUE AS published", "NULL AS bought_date"]
        else
          %w[published bought_date]
        end

      columns.flatten
    end

    def published_condition(platform, condition)
      return condition if shop_platform?(platform) && published == true
      return condition.where(id: nil) if shop_platform?(platform) && published == false

      condition.where(published:)
    end

    def yahoo_auction_buyable_condition(platform, condition)
      return condition unless platform == "yahoo_auction" && yahoo_auction_buyable && published

      condition.where(
        "(end_date <= ?) OR (buyout_price IS NOT NULL AND buyout_price <= ?)",
        Time.current.since(1.day), product.yahoo_auction_crawl_setting.max_price
      )
    end

    def build_order_sql
      return "updated_at asc" if SORT_TYPES.exclude?(sort) || ORDER_TYPES.exclude?(order)

      "#{sort} #{order}"
    end

    def normalize(result)
      result["published"] = result["published"] == 1
      result
    end

    def shop_platform?(platform)
      %w[janpara iosys].include?(platform)
    end

    def product
      @product ||= Product.find(product_id)
    end
  end
end
