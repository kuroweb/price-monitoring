# 検索して商品情報を取得する
module Search
  class RetrieveRelatedProducts
    COMMON_COLUMNS = %w[name price thumbnail_url published bought_date created_at updated_at].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @product_id = params[:product_id]
      @published = params[:published] || [true, false]
      @page = params[:page] || 1
      @per = params[:per] || 10
      @offset = (page - 1) * per
    end

    def call
      execute
      related_products
    end

    private

    attr_reader :product_id, :published, :page, :per, :offset

    def execute
      results = ActiveRecord::Base.connection.exec_query(build_sql_query)

      results.each { |result| related_products.add(RelatedProduct.new(normalize(result))) }
    end

    def build_sql_query
      <<~SQL.squish
        #{build_sql_for('mercari')}
        UNION
        #{build_sql_for('yahoo_auction')}
        ORDER BY
          updated_at DESC
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

    def related_products
      @related_products ||= RelatedProducts.new
    end
  end
end
