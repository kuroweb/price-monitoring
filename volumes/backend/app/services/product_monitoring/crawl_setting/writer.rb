module ProductMonitoring
  class CrawlSetting
    # 収集設定の入力を検証・正規化して保存する
    class Writer
      MAX_URLS = 5
      MAX_KEYWORDS = 50
      # min_price・max_price は int 列
      MAX_PRICE = 2_147_483_647
      CONDITION_COLUMNS = %w[required_keywords negative_keywords min_price max_price].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(crawl_setting:, params:)
        raise ArgumentError, "収集設定の形式が不正です" unless params.respond_to?(:to_h)

        @crawl_setting = crawl_setting
        @values = params.to_h.deep_symbolize_keys
      end

      def call
        assign
        ProductMonitoring::CrawlSetting.transaction do
          crawl_setting.save!
          # 条件を変えたら、新しい条件に一致しなくなった保存済みの結果をすぐに取り除く
          if crawl_setting.saved_changes.keys.intersect?(CONDITION_COLUMNS)
            Crawling::CrawlResultCleaner.call(crawl_setting:)
          end
        end
        crawl_setting
      end

      private

      attr_reader :crawl_setting, :values

      # 検索ワードから作るURLも、保存前にサイトの条件（Yahoo!フリマの検索ワードなど）で検証する
      def assign
        normalize
        crawl_setting.assign_attributes(
          values.slice(:name, :enabled, :search_keyword, :platforms, :search_urls, *CONDITION_COLUMNS.map(&:to_sym))
        )
        Crawling::UrlRouter.call(crawl_setting:)
      end

      def normalize
        validate_name
        normalize_prices
        %i[required_keywords negative_keywords].each { |key| values[key] = keywords(values.fetch(key, [])) }
        normalize_urls
        normalize_search
        values[:enabled] = boolean(values.fetch(:enabled, false))
      end

      def validate_name
        name = values[:name]
        return if name.is_a?(String) && !name.strip.empty? && name.length <= 255

        raise ArgumentError, "名前は1〜255文字で入力してください"
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

      def normalize_urls
        urls = values.fetch(:search_urls, [])
        raise ArgumentError, "検索結果URLは正しい形式で5件まで指定できます" unless valid_urls?(urls)

        values[:search_urls] = urls.map(&:strip).reject(&:empty?)
        raise ArgumentError, "同じ検索結果URLが重複しています" if values[:search_urls].uniq.size != values[:search_urls].size
      end

      def valid_urls?(urls)
        urls.is_a?(Array) && urls.size <= MAX_URLS && urls.all? { |url| url.is_a?(String) && url.bytesize <= 2048 }
      end

      def normalize_search
        search_keyword = values[:search_keyword]
        valid = search_keyword.nil? || (search_keyword.is_a?(String) && search_keyword.length <= 255)
        raise ArgumentError, "検索ワードは255文字以内で入力してください" unless valid

        values[:search_keyword] = search_keyword.to_s.strip.presence
        normalize_platforms
        validate_search
      end

      def normalize_platforms
        platforms = values.fetch(:platforms, [])
        names = Crawling::UrlRouter::PLATFORMS.map { |platform| platform::ListPage::SearchUrl::PLATFORM }
        valid = platforms.is_a?(Array) && (platforms - names).empty?
        raise ArgumentError, "サイトの指定が不正です" unless valid

        values[:platforms] = platforms.uniq
      end

      def validate_search
        has_keyword = values[:search_keyword].present?
        raise ArgumentError, "検索ワードとサイトを両方指定してください" if has_keyword != values[:platforms].any?
        return if has_keyword || values[:search_urls].any?

        raise ArgumentError, "検索ワードとサイト、または検索結果URLを1件以上指定してください"
      end

      def boolean(value)
        return value if [true, false].include?(value)
        return value == "true" if %w[true false].include?(value)

        raise ArgumentError, "有効状態はtrueまたはfalseで指定してください"
      end
    end
  end
end
