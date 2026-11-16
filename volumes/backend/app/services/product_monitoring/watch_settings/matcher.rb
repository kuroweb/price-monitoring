module ProductMonitoring
  module WatchSettings
    # 出品のハッシュか商品計測結果のレコードが、モニタリング設定の必須語・除外語・価格帯に一致するかを判定する。
    # 価格帯は上下限を含み、必須語はすべて、除外語はどれか1つを含むかで判定する。
    class Matcher
      def self.call(...)
        new(...).call
      end

      def initialize(product_watch_setting:, listing:)
        @product_watch_setting = product_watch_setting
        @listing = listing
      end

      def call
        price_match? && keywords_match?
      end

      private

      attr_reader :product_watch_setting, :listing

      def price_match?
        min_price = product_watch_setting.min_price
        max_price = product_watch_setting.max_price
        return true if min_price.nil? && max_price.nil?

        price = listing[:price]
        return false if price.nil?

        (min_price.nil? || price >= min_price) && (max_price.nil? || price <= max_price)
      end

      def keywords_match?
        name = normalize_keyword(listing[:name])
        required = normalize_keywords(product_watch_setting.required_keywords)
        excluded = normalize_keywords(product_watch_setting.exclude_keywords)
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
