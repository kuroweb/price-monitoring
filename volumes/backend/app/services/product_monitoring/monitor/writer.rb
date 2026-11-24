module ProductMonitoring
  class Monitor
    # モニタリング設定の入力を検証・正規化して保存する
    class Writer
      CONDITION_COLUMNS = ExtractionCriteria::FIELDS.map(&:to_s).freeze

      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, params:)
        raise ArgumentError, "モニタリング設定の形式が不正です" unless params.respond_to?(:to_h)

        @monitor = monitor
        @values = params.to_h.deep_symbolize_keys
      end

      def call
        attributes = normalize
        if monitor.new_record?
          write(attributes)
        else
          monitor.with_lock { write(attributes) }
        end
        monitor
      end

      private

      attr_reader :monitor, :values

      def normalize
        validate_name
        ExtractionCriteria.normalize(values).merge(
          name: values[:name],
          enabled: boolean(values.fetch(:enabled, false)),
          discord_enabled: boolean(values.fetch(:discord_enabled, false)),
          newest_notification_enabled: boolean(values.fetch(:newest_notification_enabled, false))
        )
      end

      # 通知の基準は条件・有効状態を変えたら取り直し、日次相場は条件を変えたら集計し直す
      def write(attributes)
        setting = monitor
        setting.assign_attributes(attributes)
        changed = setting.changes.keys
        condition_changed = setting.persisted? && changed.intersect?(CONDITION_COLUMNS)
        setting.last_lowest_signature = nil if changed.intersect?(%w[enabled discord_enabled] + CONDITION_COLUMNS)
        setting.newest_notified_until = nil if changed.intersect?(%w[newest_notification_enabled] + CONDITION_COLUMNS)
        setting.save!
        setting.daily_market_prices.delete_all if condition_changed
      end

      def validate_name
        name = values[:name]
        return if name.is_a?(String) && !name.strip.empty? && name.length <= 255

        raise ArgumentError, "名前は1〜255文字で入力してください"
      end

      def boolean(value)
        return value if [true, false].include?(value)
        return value == "true" if %w[true false].include?(value)

        raise ArgumentError, "有効状態はtrueまたはfalseで指定してください"
      end
    end
  end
end
