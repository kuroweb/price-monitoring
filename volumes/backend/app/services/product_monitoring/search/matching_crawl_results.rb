module ProductMonitoring
  module Search
    # 抽出条件に合う保存済みの収集結果を、詳細向けに6件返す。
    # 販売状態と並びはサーバで決める。続きは前の最後の行の並びキーと id から読み、ページ番号は受け取らない。
    # 新着順のカーソルは recency_at と id。recency_at が空の行は、空のグループの中の id。
    # 価格順のカーソルは price と id。
    # 新着順は recency_at の降順、空は末尾、同じ位置は id の降順。
    # 価格順は価格の昇順または降順で、同じ価格は id の降順。
    # 売れた日が無い売り切れは末尾に残し、売り切れとすべてから落とさない。
    # 走査は6件と、続きがあるかの確認までで止める。一覧の8件は NewestCrawlResults のまま。
    class MatchingCrawlResults
      BATCH_SIZE = 100
      # 詳細のグリッドは最も広いとき 6 列。一度に返す件数はその一段に収まる数。
      PAGE_SIZE = 6
      SALE_STATUSES = %w[all on_sale sold].freeze
      SORTS = %w[newest price_asc price_desc].freeze
      Page = Struct.new(:listings, :per_page, :has_more, :cursor, keyword_init: true)

      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, sale_status: "all", sort: "newest", cursor: nil)
        @monitor = monitor
        @sale_status = sale_status.to_s
        @sort = sort.to_s
        @raw_cursor = cursor
      end

      def call
        validate!
        @cursor = CrawlResultCursor.parse(sort:, raw: @raw_cursor)
        prepare
        ProductMonitoring::CrawlResult.transaction { walk }
        Page.new(listings: @listings, per_page: PAGE_SIZE, has_more: @has_more,
                 cursor: CrawlResultCursor.payload(sort:, listing: @listings.last))
      end

      private

      attr_reader :monitor, :sale_status, :sort, :cursor

      def validate!
        raise ArgumentError, "販売状態が不正です" unless SALE_STATUSES.include?(sale_status)
        raise ArgumentError, "並びが不正です" unless SORTS.include?(sort)
      end

      def prepare
        @listings = []
        @seen = Set.new
        @has_more = false
      end

      def walk
        catch(:done) { ordered_scopes.each { |scope, batch, start| read_scope(scope, batch, start) } }
      end

      def read_scope(scope, batch, start)
        relation = start ? scope.where(after_clause(batch.fetch(:cursor), batch.fetch(:order), start)) : scope
        relation.find_each(batch_size: BATCH_SIZE, **batch) { |result| consider(result) }
      end

      # 並びのその位置より後ろ。前の行自体は含まない。
      def after_clause(columns, orders, values)
        parts = Array(columns).zip(Array(orders), Array(values))
        column, order, value = parts.pop
        clause = past(column, order, value)
        parts.reverse_each do |col, ord, val|
          clause = past(col, ord, val).or(table[col].eq(val).and(clause))
        end
        clause
      end

      def past(column, order, value)
        node = table[column]
        order.to_sym == :desc ? node.lt(value) : node.gt(value)
      end

      def table
        ProductMonitoring::CrawlResult.arel_table
      end

      def consider(result)
        return unless Monitor::Matcher.call(monitor:, listing: result)
        return unless @seen.add?([result.platform, result.external_id])
        return @listings << result if @listings.size < PAGE_SIZE

        @has_more = true
        throw :done
      end

      def ordered_scopes
        return price_scopes unless sort == "newest"

        newest_scopes
      end

      def newest_scopes
        return [undated_scope([cursor[:id]])] if cursor&.[](:group) == :undated

        dated_start = cursor ? [cursor[:recency_at], cursor[:id]] : nil
        [dated_scope(dated_start), undated_scope(nil)]
      end

      def dated_scope(start)
        [candidates.where.not(recency_at: nil), { cursor: %i[recency_at id], order: %i[desc desc] }, start]
      end

      def undated_scope(start)
        [candidates.where(recency_at: nil), { cursor: :id, order: :desc }, start]
      end

      def price_scopes
        direction = sort == "price_asc" ? :asc : :desc
        start = cursor ? [cursor[:price], cursor[:id]] : nil
        [[candidates, { cursor: %i[price id], order: [direction, :desc] }, start]]
      end

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        apply_sale_status(apply_price(ProductMonitoring::CrawlResult.not_excluded))
      end

      def apply_price(results)
        min_price = monitor.min_price
        max_price = monitor.max_price
        return results unless min_price || max_price

        results.where(price: min_price..max_price)
      end

      def apply_sale_status(results)
        sold = ProductMonitoring::CrawlResult.arel_table[:sold]
        case sale_status
        when "on_sale" then results.where(sold.eq(nil).or(sold.eq(false)))
        when "sold" then results.where(sold.eq(true))
        else results
        end
      end
    end
  end
end
