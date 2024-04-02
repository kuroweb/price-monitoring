# Productに紐づく関連商品を取得する
# 一覧表示用の検索クラス
module Search
  class RetrieveRelatedProduct
    COMMON_COLUMNS = %w[product_id name price thumbnail_url published bought_date created_at updated_at].freeze

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

      RelatedProducts.new(records.map { |record| RelatedProduct.new(normalize(record)) })
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
        ORDER BY
          #{sort} #{order}
        LIMIT
          #{per} OFFSET #{offset}
      SQL
    end

    def build_sql_for(platform)
      product.send("#{platform}_products")
             .where(published:)
             .select(["#{platform}_id AS external_id"] + COMMON_COLUMNS)
             .to_sql
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
