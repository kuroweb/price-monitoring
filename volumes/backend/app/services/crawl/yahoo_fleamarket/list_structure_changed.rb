# 一覧ページの DOM 構造が想定と合わず商品行を 1 件も抽出できない
module Crawl
  module YahooFleamarket
    class ListStructureChanged < StandardError
      def initialize
        super("一覧 DOM から商品を 1 件も抽出できません")
      end
    end
  end
end
