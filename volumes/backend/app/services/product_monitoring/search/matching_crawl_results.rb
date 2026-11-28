module ProductMonitoring
  module Search
    # 抽出条件に合う保存済みの収集結果を、詳細向けに1ページ返す。
    # 販売状態と並びはサーバで決める。新着順は recency_at の降順、空は末尾、同じ位置は id の降順。
    # 価格順は価格の昇順または降順で、同じ価格は id の降順。
    # 売れた日が無い売り切れは末尾に残し、売り切れとすべてから落とさない。
    # 走査は指定ページと、次のページがあるかの確認までで止める。一覧の8件は NewestCrawlResults のまま。
    class MatchingCrawlResults
      class InvalidQuery < ArgumentError; end

      BATCH_SIZE = 100
      PAGE_SIZE = 12
      SALE_STATUSES = %w[all on_sale sold].freeze
      SORTS = %w[newest price_asc price_desc].freeze
      Page = Struct.new(:listings, :page, :per_page, :has_more, keyword_init: true)

      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, sale_status: "all", sort: "newest", page: 1)
        @monitor = monitor
        @sale_status = sale_status.to_s
        @sort = sort.to_s
        @page = parse_page(page)
      end

      def call
        validate!
        prepare
        ProductMonitoring::CrawlResult.transaction { walk }
        build_page
      end

      private

      attr_reader :monitor, :sale_status, :sort, :page

      def parse_page(value)
        text = value.to_s
        return Integer(text, 10) if /\A[0-9]+\z/.match?(text)

        raise InvalidQuery, "page は1以上の整数で指定してください"
      end

      def validate!
        raise InvalidQuery, "販売状態が不正です" unless SALE_STATUSES.include?(sale_status)
        raise InvalidQuery, "並びが不正です" unless SORTS.include?(sort)
        raise InvalidQuery, "page は1以上の整数で指定してください" if page < 1
      end

      def prepare
        @listings = []
        @seen = Set.new
        @matched = 0
        @has_more = false
      end

      def walk
        catch(:done) { ordered_scopes.each { |scope, batch| read_scope(scope, batch) } }
      end

      def read_scope(scope, batch)
        scope.find_each(batch_size: BATCH_SIZE, **batch) { |result| consider(result) }
      end

      def consider(result)
        return unless Monitor::Matcher.call(monitor:, listing: result)
        return unless @seen.add?([result.platform, result.external_id])

        @matched += 1
        return if @matched <= offset
        return @listings << result if @listings.size < PAGE_SIZE

        @has_more = true
        throw :done
      end

      def offset
        (page - 1) * PAGE_SIZE
      end

      def ordered_scopes
        return price_scopes unless sort == "newest"

        [
          [candidates.where.not(recency_at: nil), { cursor: %i[recency_at id], order: %i[desc desc] }],
          [candidates.where(recency_at: nil), { cursor: :id, order: :desc }]
        ]
      end

      def price_scopes
        direction = sort == "price_asc" ? :asc : :desc
        [[candidates, { cursor: %i[price id], order: [direction, :desc] }]]
      end

      def build_page
        Page.new(listings: @listings, page:, per_page: PAGE_SIZE, has_more: @has_more)
      end

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        apply_sale_status(apply_price(ProductMonitoring::CrawlResult.not_excluded.not_excluded_seller))
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
