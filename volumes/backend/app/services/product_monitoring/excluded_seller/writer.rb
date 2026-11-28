module ProductMonitoring
  class ExcludedSeller
    # 除外する出品者の入力を検証・正規化して登録する。同じサイトの同じ出品者IDは DB の一意制約で重ねて登録しない
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

      # 前後の空白だけを除き、大文字小文字や全角半角は変えずにサイトの表記のまま比べる
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
