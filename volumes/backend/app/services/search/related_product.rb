# Productに紐づく関連商品を取得する
# 一覧表示用の検索クラス
module Search
  class RelatedProduct # rubocop:disable Metrics/ClassLength
    PLATFORM_MASK_TYPES = %w[
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

    SORT_TYPES = %w[price bought_date created_at updated_at].freeze
    ORDER_TYPES = %w[desc asc].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @product_id = params[:product_id]
      @platform_mask = params[:platform_mask]
      @page = params[:page].to_i.nonzero? || 1
      @per = params[:per].to_i.nonzero? || 10
      @offset = (page - 1) * per
      @sort = params[:sort] || "updated_at"
      @order = params[:order] || "desc"
    end

    def call
      records = exec_query
      related_products = ::RelatedProducts.new(records.map { |record| ::RelatedProduct.new(normalize(record)) })
      handle_errors(related_products)

      related_products
    end

    private

    attr_reader :product_id, :platform_mask, :page, :per, :offset, :sort, :order

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
      masks = platform_mask.split(",").select { |mask| PLATFORM_MASK_TYPES.include?(mask) }.uniq
      masks.map { |mask| build_sql_for(*mask.split(".")) }.join(" UNION ")
    end

    def build_sql_for(platform, option)
      case option
      when "all"
        all_sql(platform)
      when "published"
        published_sql(platform)
      when "unpublished"
        unpublished_sql(platform)
      when "buyable"
        buyable_sql(platform)
      end
    end

    def all_sql(platform)
      base_condition(platform).to_sql
    end

    def published_sql(platform)
      condition = base_condition(platform)
      condition = published_condition(condition, true)
      condition.to_sql
    end

    def unpublished_sql(platform)
      condition = base_condition(platform)
      condition = published_condition(condition, false)
      condition.to_sql
    end

    def buyable_sql(platform)
      condition = base_condition(platform)
      condition = published_condition(condition, true)
      condition = buyable_condition(condition)
      condition.to_sql
    end

    def base_condition(platform)
      product.send(:"#{platform}_products")
             .select(common_columns(platform) + additional_columns(platform))
    end

    def common_columns(platform)
      [
        "'#{platform}' AS platform", "external_id",
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

    def published_condition(condition, published)
      condition.where(published:)
    end

    def buyable_condition(condition)
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
      result["bought_date"] = result["bought_date"]&.in_time_zone
      result["end_date"] = result["end_date"]&.in_time_zone
      result["created_at"] = result["created_at"]&.in_time_zone
      result["updated_at"] = result["updated_at"]&.in_time_zone

      result
    end

    def shop_platform?(platform)
      %w[janpara iosys pc_koubou used_sofmap].include?(platform)
    end

    def handle_errors(related_products)
      raise StandardError, related_products.errors.full_messages.join(", ") unless related_products.valid?
    end

    def product
      @product ||= Product.find(product_id)
    end
  end
end
