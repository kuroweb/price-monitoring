# データ抽出用クエリをビルドするクラス
module RetrieveRelatedProducts
  class BuildSql
    def self.call(...)
      new(...).call
    end

    def initialize(params: {})
      @product_id = params[:product_id]
      @platform_mask = params[:platform_mask]
      @per = params[:per]
      @offset = params[:offset]
      @sort = params[:sort]
      @order = params[:order]
    end

    def call
      build_sql
    end

    private

    attr_reader :product_id, :platform_mask, :per, :offset, :sort, :order

    def build_sql
      <<~SQL.squish
        #{build_platform_sql}
        ORDER BY
          #{sort} #{order}
        LIMIT
          #{per} OFFSET #{offset}
      SQL
    end

    def build_platform_sql
      masks = platform_mask.split(",")
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

    def shop_platform?(platform)
      %w[janpara iosys pc_koubou used_sofmap].include?(platform)
    end

    def product
      @product ||= Product.find(product_id)
    end
  end
end
