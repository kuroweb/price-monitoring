# Productに紐づく関連商品を取得する
# 一覧表示用の検索クラス
module Search
  class RetrieveRelatedProduct
    SORT_OPTIONS = %w[bought_date created_at updated_at].freeze
    ORDER_OPTIONS = %w[desc asc].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @product_id = params[:product_id]
      @published = params[:published] || [true, false]
      @page = params[:page].to_i.nonzero? || 1
      @per = params[:per].to_i.nonzero? || 10
      @offset = (page - 1) * per
      @sort = params[:sort] || "updated_at"
      @order = params[:order] || "desc"
    end

    def call
      records = query
      related_products = RelatedProducts.new(records.map { |record| RelatedProduct.new(normalize(record)) })

      raise StandardError, related_products.errors unless related_products.valid?

      related_products
    end

    private

    attr_reader :product_id, :published, :page, :per, :offset, :sort, :order

    def query
      ActiveRecord::Base.connection.exec_query(sql)
    end

    def sql
      <<~SQL.squish
        #{build_sql_for('mercari')}
        UNION
        #{build_sql_for('yahoo_auction')}
        UNION
        #{build_sql_for('yahoo_fleamarket')}
        ORDER BY
          #{build_order_sql}
        LIMIT
          #{per} OFFSET #{offset}
      SQL
    end

    def build_sql_for(platform)
      product.send("#{platform}_products")
             .where(published:)
             .select(common_columns(platform) + additional_columns(platform))
             .to_sql
    end

    def build_order_sql
      return "updated_at asc" if SORT_OPTIONS.exclude?(sort) || ORDER_OPTIONS.exclude?(order)

      "#{sort} #{order}"
    end

    def common_columns(platform)
      [
        "'#{platform}' AS platform", "#{platform}_id AS external_id",
        "product_id", "name", "price", "thumbnail_url", "published",
        "bought_date", "created_at", "updated_at"
      ]
    end

    def additional_columns(platform)
      if platform == "yahoo_auction"
        %w[buyout_price end_date]
      else
        ["NULL AS buyout_price", "NULL AS end_date"]
      end
    end

    def normalize(result)
      result["published"] = result["published"] == 1
      result
    end

    def product
      @product ||= Product.find(product_id)
    end
  end
end
