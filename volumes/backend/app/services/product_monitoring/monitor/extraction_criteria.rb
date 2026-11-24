module ProductMonitoring
  class Monitor
    class ExtractionCriteria
      class Invalid < ArgumentError; end

      FIELDS = %i[required_keywords negative_keywords min_price max_price].freeze
      MAX_KEYWORDS = 50
      MAX_PRICE = 2_147_483_647

      def self.normalize(values)
        min_price = price(values[:min_price])
        max_price = price(values[:max_price])
        raise Invalid, "最低価格は最高価格以下にしてください" if min_price && max_price && min_price > max_price

        { min_price:, max_price:,
          required_keywords: keywords(values.fetch(:required_keywords, [])),
          negative_keywords: keywords(values.fetch(:negative_keywords, [])) }
      end

      def self.price(value)
        return if value.nil?

        valid = value.to_s.match?(/\A\d+\z/) && value.to_i <= MAX_PRICE
        raise Invalid, "価格は0以上の整数で入力してください" unless valid

        value.to_i
      end

      def self.keywords(words)
        raise Invalid, "語句は各255文字以内、50件まで指定できます" unless valid_keywords?(words)

        words.map(&:strip).reject(&:empty?).uniq
      end

      def self.valid_keywords?(words)
        words.is_a?(Array) && words.size <= MAX_KEYWORDS &&
          words.all? { |word| word.is_a?(String) && word.length <= 255 }
      end

      private_class_method :price, :keywords, :valid_keywords?
    end
  end
end
