module ProductMonitoring
  class Monitor
    # 出品のハッシュか収集結果のレコードが、モニタリング設定の抽出条件（必須語・除外語・価格帯）に一致するかを判定する。
    # 価格帯は上下限を含み、必須語はすべて、除外語はどれか1つを含むかで判定する。
    class Matcher
      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, listing:)
        @monitor = monitor
        @listing = listing
      end

      def call
        price_match? && keywords_match?
      end

      private

      attr_reader :monitor, :listing

      def price_match?
        min_price = monitor.min_price
        max_price = monitor.max_price
        return true if min_price.nil? && max_price.nil?

        price = listing[:price]
        return false if price.nil?

        (min_price.nil? || price >= min_price) && (max_price.nil? || price <= max_price)
      end

      def keywords_match?
        name = normalize_keyword(listing[:name])
        required = normalize_keywords(monitor.required_keywords)
        excluded = normalize_keywords(monitor.negative_keywords)
        required.all? { |word| name.include?(word) } && excluded.none? { |word| name.include?(word) }
      end

      def normalize_keywords(words)
        Array(words).map { |word| normalize_keyword(word) }.reject(&:empty?)
      end

      # 全角半角・大文字小文字・空白の有無を区別せずに比べる
      def normalize_keyword(value)
        value.to_s.unicode_normalize(:nfkc).downcase.gsub(/[[:space:]]+/, "")
      end
    end
  end
end
