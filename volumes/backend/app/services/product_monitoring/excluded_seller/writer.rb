module ProductMonitoring
  class ExcludedSeller
    class Writer
      def self.call(...)
        new(...).call
      end

      def initialize(params:)
        raise ArgumentError, "除外する出品者の形式が不正です" unless params.respond_to?(:to_h)

        @values = params.to_h.deep_symbolize_keys
      end

      def call
        ProductMonitoring::ExcludedSeller.create!(platform:, seller_id:)
      end

      private

      attr_reader :values

      def platform
        platform = values[:platform]
        raise ArgumentError, "サイトの指定が不正です" unless ProductMonitoring::ExcludedSeller::PLATFORMS.include?(platform)

        platform
      end

      # サイトの表記のまま完全一致で照合するため、語句と違い大文字小文字や全角半角を正規化しない
      def seller_id
        seller_id = values[:seller_id]
        seller_id = seller_id.strip if seller_id.is_a?(String)
        valid = seller_id.is_a?(String) && seller_id.match?(ProductMonitoring::CrawlResult::SELLER_ID_FORMAT)
        raise ArgumentError, "出品者IDは英数字と「_」「.」「-」の255文字以内で入力してください" unless valid

        seller_id
      end
    end
  end
end
