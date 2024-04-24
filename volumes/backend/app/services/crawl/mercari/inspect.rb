# 現在の計測設定とマッチしないレコードを削除する
module Crawl
  module Mercari
    class Inspect
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        deletable.delete_all
      end

      private

      attr_reader :product

      def deletable
        MercariProduct
          .where(product_id: product.id)
          .merge(
            price_condition
              .or(required_keywords_condition)
              .or(exclude_keywords_conditon)
          )
      end

      def price_condition
        price_range = product.mercari_crawl_setting.min_price..product.mercari_crawl_setting.max_price
        MercariProduct.where.not(price: price_range)
      end

      def required_keywords_condition
        return MercariProduct.none if required_keywords.blank?

        required_keywords.map do |required_keyword|
          MercariProduct.where.not("name LIKE ?", "%#{required_keyword}%")
        end.reduce(&:or)
      end

      def exclude_keywords_conditon
        return MercariProduct.none if exclude_keywords.blank?

        exclude_keywords.map do |exclude_keyword|
          MercariProduct.where("name LIKE ?", "%#{exclude_keyword}%")
        end.reduce(&:or)
      end

      def required_keywords
        @required_keywords ||=
          product.mercari_crawl_setting
                 .mercari_crawl_setting_required_keywords
                 .pluck(:keyword)
                 .map { |keyword| normalize_keyword(keyword) }
      end

      def exclude_keywords
        @exclude_keywords ||=
          product.mercari_crawl_setting
                 .mercari_crawl_setting_exclude_keywords
                 .pluck(:keyword)
                 .map { |keyword| normalize_keyword(keyword) }
      end

      def normalize_keyword(keyword)
        keyword.tr("Ａ-Ｚ０-９", "A-Z0-9").downcase
      end
    end
  end
end
