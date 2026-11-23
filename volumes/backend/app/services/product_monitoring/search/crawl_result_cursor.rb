module ProductMonitoring
  module Search
    # 詳細の続きの位置。新着順は recency_at と id、空のグループは id、価格順は price と id。
    class CrawlResultCursor
      def self.parse(sort:, raw:)
        new(sort:, raw:).parse
      end

      def self.payload(sort:, listing:)
        return if listing.nil?
        return { recency_at: listing.recency_at&.iso8601(6), id: listing.id } if sort == "newest"

        { price: listing.price, id: listing.id }
      end

      def initialize(sort:, raw:)
        @sort = sort
        @raw = raw
      end

      def parse
        return if raw.nil?
        raise ArgumentError, "カーソルが不正です" unless raw.is_a?(Hash)

        values = raw.transform_keys(&:to_s).slice("id", "recency_at", "price").compact_blank
        return if values.empty?

        id = positive_id(values["id"])
        sort == "newest" ? newest(values, id) : price(values, id)
      end

      private

      attr_reader :sort, :raw

      def newest(values, id)
        raise ArgumentError, "カーソルが不正です" if values.key?("price")
        return { group: :undated, id: } unless values.key?("recency_at")

        { group: :dated, recency_at: time(values["recency_at"]), id: }
      end

      def price(values, id)
        raise ArgumentError, "カーソルが不正です" if values.key?("recency_at") || !values.key?("price")

        { price: integer(values["price"]), id: }
      end

      def positive_id(value)
        id = integer(value)
        raise ArgumentError, "カーソルが不正です" if id < 1

        id
      end

      def integer(value)
        Integer(value)
      rescue ArgumentError, TypeError
        raise ArgumentError, "カーソルが不正です"
      end

      def time(value)
        return value if value.is_a?(Time) || value.is_a?(ActiveSupport::TimeWithZone)

        parsed = Time.iso8601(value.to_s)
        raise ArgumentError, "カーソルが不正です" if parsed.nil?

        parsed
      rescue ArgumentError, TypeError
        raise ArgumentError, "カーソルが不正です"
      end
    end
  end
end
