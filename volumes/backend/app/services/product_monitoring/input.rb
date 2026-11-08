module ProductMonitoring
  class Input
    MAX_URLS = 5
    MAX_KEYWORDS = 50
    MAX_EXCLUSIONS = 100
    MAX_PRICE = 2_147_483_647

    def self.call(...)
      new(...).call
    end

    def self.strings(rows, max:, message:)
      valid = rows.is_a?(Array) && rows.size <= max && rows.all? { |v| valid_string?(v) }
      raise ArgumentError, message unless valid

      rows.map(&:strip).reject(&:empty?).uniq
    end

    def self.valid_string?(value)
      value.is_a?(String) && value.length <= 255
    end

    def self.boolean(value)
      return value if [true, false].include?(value)
      return value == "true" if %w[true false].include?(value)

      raise ArgumentError, "有効状態はtrueまたはfalseで指定してください"
    end

    def initialize(params:, require_name: false, require_search_urls: false)
      raise ArgumentError, "計測設定の形式が不正です" unless params.respond_to?(:to_h)

      @values = params.to_h.deep_symbolize_keys
      @require_name = require_name
      @require_search_urls = require_search_urls
    end

    def call
      validate_name
      normalize_prices
      normalize_keywords
      normalize_urls
      normalize_search
      values[:enabled] = self.class.boolean(values.fetch(:enabled, false))
      values
    end

    private

    attr_reader :values, :require_name, :require_search_urls

    def validate_name
      name = values[:name]
      return unless require_name && (!name.is_a?(String) || name.strip.empty? || name.length > 255)

      raise ArgumentError, "名前は1〜255文字で入力してください"
    end

    def normalize_prices
      %i[min_price max_price].each do |key|
        value = values[key]
        next if value.nil?

        values[key] = normalize_price(value)
      end
      validate_price_range
    end

    def validate_price_range
      return unless values[:min_price] && values[:max_price] && values[:min_price] > values[:max_price]

      raise ArgumentError, "最低価格は最高価格以下にしてください"
    end

    def normalize_price(value)
      raise ArgumentError, "価格は0以上の整数で入力してください" unless value.to_s.match?(/\A\d+\z/) && value.to_i <= MAX_PRICE

      value.to_i
    end

    def normalize_keywords
      %i[required_keywords exclude_keywords].each do |key|
        values[key] = self.class.strings(values.fetch(key, []), max: MAX_KEYWORDS,
                                                                message: "語句は各255文字以内、50件まで指定できます")
      end
      values[:exclude_external_ids] = self.class.strings(
        values.fetch(:exclude_external_ids, []), max: MAX_EXCLUSIONS, message: "除外する出品IDは100件まで指定できます"
      )
    end

    def normalize_urls
      urls = values.fetch(:search_urls, [])
      raise ArgumentError, "検索結果URLは正しい形式で5件まで指定できます" unless valid_urls?(urls)

      values[:search_urls] = urls.map(&:strip).reject(&:empty?)
      validate_normalized_urls
    end

    def validate_normalized_urls
      raise ArgumentError, "同じ検索結果URLが重複しています" if values[:search_urls].uniq.size != values[:search_urls].size
    end

    def normalize_search
      keyword = values[:keyword]
      raise ArgumentError, "検索語は255文字以内で入力してください" unless keyword.nil? || self.class.valid_string?(keyword)

      values[:keyword] = keyword.to_s.strip.presence
      platforms = values.fetch(:platforms, [])
      valid = platforms.is_a?(Array) &&
              platforms.all? { |platform| UrlRouter::SITES.any? { |site| site::PLATFORM == platform } }
      raise ArgumentError, "サイトの指定が不正です" unless valid

      values[:platforms] = platforms.uniq
      has_keyword = values[:keyword].present?
      has_platforms = values[:platforms].any?
      raise ArgumentError, "検索語とサイトを両方指定してください" if has_keyword != has_platforms
      if require_search_urls && !has_keyword && values[:search_urls].empty?
        raise ArgumentError, "検索語とサイト、または検索結果URLを1件以上指定してください"
      end
    end

    def valid_urls?(urls)
      urls.is_a?(Array) && urls.size <= MAX_URLS && urls.all? { |url| url.is_a?(String) && url.bytesize <= 2048 }
    end
  end
end
