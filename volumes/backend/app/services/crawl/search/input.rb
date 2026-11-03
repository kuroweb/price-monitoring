module Crawl::Search
  class Input
    MAX_URLS = 5
    MAX_KEYWORDS = 50
    MAX_EXCLUSIONS = 100
    MAX_PRICE = 2_147_483_647

    def self.call(params:, require_name: false)
      raise ArgumentError, "計測設定の形式が不正です" unless params.respond_to?(:to_h)

      values = params.to_h.deep_symbolize_keys
      name = values[:name]
      if require_name && (!name.is_a?(String) || name.strip.empty? || name.length > 255)
        raise ArgumentError, "名前は1〜255文字で入力してください"
      end
      %i[min_price max_price].each do |key|
        value = values[key]
        next if value.nil?

        unless value.to_s.match?(/\A\d+\z/) && value.to_i <= MAX_PRICE
          raise ArgumentError, "価格は0以上の整数で入力してください"
        end
        values[key] = value.to_i
      end
      if values[:min_price] && values[:max_price] && values[:min_price] > values[:max_price]
        raise ArgumentError, "最低価格は最高価格以下にしてください"
      end
      %i[required_keywords exclude_keywords].each do |key|
        rows = values.fetch(key, [])
        unless rows.is_a?(Array) && rows.size <= MAX_KEYWORDS && rows.all? { |v| v.is_a?(String) && v.length <= 255 }
          raise ArgumentError, "語句は各255文字以内、50件まで指定できます"
        end
        values[key] = rows.map(&:strip).reject(&:empty?).uniq
      end
      rows = values.fetch(:excluded_listings, [])
      unless rows.is_a?(Array) && rows.size <= MAX_EXCLUSIONS && rows.all? { |row| row.is_a?(Hash) }
        raise ArgumentError, "個別出品除外は100件まで指定できます"
      end
      values[:excluded_listings] = rows.map do |row|
        unless %w[mercari iosys].include?(row[:platform]) && row[:external_id].is_a?(String) && row[:external_id].length.between?(1, 255)
          raise ArgumentError, "除外するサイトと出品IDを確認してください"
        end
        row.slice(:platform, :external_id)
      end.uniq
      urls = values.fetch(:urls, [])
      unless urls.is_a?(Array) && urls.size <= MAX_URLS && urls.all? { |row| row.is_a?(Hash) && row[:url].is_a?(String) && row[:url].bytesize <= 2048 }
        raise ArgumentError, "取得URLは正しい形式で5件まで指定できます"
      end
      raise ArgumentError, "取得URLを1件以上指定してください" if require_name && urls.empty?

      values[:urls] = urls.map { |row| row.slice(:url).merge(enabled: boolean(row.fetch(:enabled, true))) }
      values[:enabled] = boolean(values.fetch(:enabled, true))
      values
    end

    def self.boolean(value)
      return value if value == true || value == false
      return value == "true" if %w[true false].include?(value)

      raise ArgumentError, "有効状態はtrueまたはfalseで指定してください"
    end
  end
end
