# 現在の計測設定とマッチしないレコードを削除する
module Products
  module Inspect
    class DeleteUsedSofmapProducts
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
        UsedSofmapProduct
          .where(product_id: product.id)
          .merge(
            price_condition
              .or(required_keywords_condition)
              .or(exclude_keywords_condition)
              .or(exclude_products_condition)
          )
      end

      def price_condition
        price_range = used_sofmap_crawl_setting.min_price..used_sofmap_crawl_setting.max_price
        UsedSofmapProduct.where.not(price: price_range)
      end

      def required_keywords_condition
        return UsedSofmapProduct.none if required_keywords.blank?

        required_keywords.map do |required_keyword|
          UsedSofmapProduct.where.not("name LIKE ?", "%#{required_keyword}%")
        end.reduce(&:or)
      end

      def exclude_keywords_condition
        return UsedSofmapProduct.none if exclude_keywords.blank?

        exclude_keywords.map do |exclude_keyword|
          UsedSofmapProduct.where("name LIKE ?", "%#{exclude_keyword}%")
        end.reduce(&:or)
      end

      def exclude_products_condition
        return UsedSofmapProduct.none if exclude_products.blank?

        exclude_products.map do |exclude_product|
          UsedSofmapProduct.where(external_id: exclude_product)
        end.reduce(&:or)
      end

      def required_keywords
        @required_keywords ||=
          used_sofmap_crawl_setting
          .used_sofmap_crawl_setting_required_keywords
          .pluck(:keyword)
          .map { |keyword| normalize_keyword(keyword) }
      end

      def exclude_keywords
        @exclude_keywords ||=
          used_sofmap_crawl_setting
          .used_sofmap_crawl_setting_exclude_keywords
          .pluck(:keyword)
          .map { |keyword| normalize_keyword(keyword) }
      end

      def normalize_keyword(keyword)
        keyword.tr("Ａ-Ｚ０-９", "A-Z0-9").downcase
      end

      def exclude_products
        @exclude_products ||=
          used_sofmap_crawl_setting
          .used_sofmap_crawl_setting_exclude_products
          .pluck(:external_id)
      end

      def used_sofmap_crawl_setting
        @used_sofmap_crawl_setting ||= product.used_sofmap_crawl_setting
      end
    end
  end
end
