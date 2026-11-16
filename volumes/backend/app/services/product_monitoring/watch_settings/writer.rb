module ProductMonitoring
  module WatchSettings
    # 商品モニタリング設定の入力を検証・正規化して保存する
    class Writer
      MAX_KEYWORDS = 50
      # min_price・max_price は int 列
      MAX_PRICE = 2_147_483_647
      CONDITION_COLUMNS = %w[required_keywords exclude_keywords min_price max_price].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(product_watch_setting:, params:)
        raise ArgumentError, "モニタリング設定の形式が不正です" unless params.respond_to?(:to_h)

        @product_watch_setting = product_watch_setting
        @values = params.to_h.deep_symbolize_keys
      end

      def call
        attributes = normalize
        if product_watch_setting.new_record?
          write(attributes)
        else
          product_watch_setting.with_lock { write(attributes) }
        end
        product_watch_setting
      end

      private

      attr_reader :product_watch_setting, :values

      def normalize
        validate_name
        normalize_condition
        values.slice(:name, *CONDITION_COLUMNS.map(&:to_sym)).merge(
          enabled: boolean(values.fetch(:enabled, false)),
          discord_enabled: boolean(values.fetch(:discord_enabled, false))
        )
      end

      # 通知の基準は条件・有効状態を変えたら取り直し、日次相場は条件を変えたら集計し直す
      def write(attributes)
        setting = product_watch_setting
        setting.assign_attributes(attributes)
        changed = setting.changes.keys
        condition_changed = setting.persisted? && changed.intersect?(CONDITION_COLUMNS)
        setting.last_lowest_signature = nil if changed.intersect?(%w[enabled discord_enabled] + CONDITION_COLUMNS)
        setting.save!
        setting.product_aggregation_results.delete_all if condition_changed
      end

      def validate_name
        name = values[:name]
        return if name.is_a?(String) && !name.strip.empty? && name.length <= 255

        raise ArgumentError, "名前は1〜255文字で入力してください"
      end

      # 価格帯・必須語・除外語を検証して正規化する
      def normalize_condition
        normalize_prices
        %i[required_keywords exclude_keywords].each { |key| values[key] = keywords(values.fetch(key, [])) }
      end

      def normalize_prices
        min_price = values[:min_price] = price(values[:min_price])
        max_price = values[:max_price] = price(values[:max_price])
        return unless min_price && max_price && min_price > max_price

        raise ArgumentError, "最低価格は最高価格以下にしてください"
      end

      # 未入力は価格帯の上限・下限なしとする
      def price(value)
        return if value.nil?

        valid = value.to_s.match?(/\A\d+\z/) && value.to_i <= MAX_PRICE
        raise ArgumentError, "価格は0以上の整数で入力してください" unless valid

        value.to_i
      end

      def keywords(words)
        raise ArgumentError, "語句は各255文字以内、50件まで指定できます" unless valid_keywords?(words)

        words.map(&:strip).reject(&:empty?).uniq
      end

      def valid_keywords?(words)
        words.is_a?(Array) && words.size <= MAX_KEYWORDS &&
          words.all? { |word| word.is_a?(String) && word.length <= 255 }
      end

      def boolean(value)
        return value if [true, false].include?(value)
        return value == "true" if %w[true false].include?(value)

        raise ArgumentError, "有効状態はtrueまたはfalseで指定してください"
      end
    end
  end
end
