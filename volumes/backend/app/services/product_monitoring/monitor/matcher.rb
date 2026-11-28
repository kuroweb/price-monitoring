module ProductMonitoring
  class Monitor
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

      def normalize_keyword(value)
        value.to_s.unicode_normalize(:nfkc).downcase.gsub(/[[:space:]]+/, "")
      end
    end
  end
end
