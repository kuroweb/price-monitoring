module ProductMonitoring
  module Crawling
    # 一覧のデータから読んだ出品IDと出品者IDの組を、出品IDから出品者IDを引ける形にする。
    # 形式の合わない値は捨て、同じ出品IDに違う出品者IDがあれば、どちらとも決めずに不明とする
    module SellerIdMap
      def self.build(pairs)
        conflicted = Set.new
        map = {}
        pairs.each do |listing_id, seller_id|
          listing_id = identifier(listing_id)
          seller_id = identifier(seller_id)
          next unless listing_id && seller_id

          conflicted << listing_id if map.key?(listing_id) && map[listing_id] != seller_id
          map[listing_id] = seller_id
        end
        map.except(*conflicted)
      end

      def self.identifier(value)
        text = value.is_a?(Integer) ? value.to_s : value
        text if text.is_a?(String) && text.match?(ProductMonitoring::CrawlResult::SELLER_ID_FORMAT)
      end
      private_class_method :identifier
    end
  end
end
