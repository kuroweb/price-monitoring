# 現在の計測設定とマッチしないレコードを削除する
module Products
  module Inspect
    class DeleteJanparaProducts
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
        JanparaProduct
          .where(product_id: product.id)
          .merge(
            price_condition
              .or(required_keywords_condition)
              .or(exclude_keywords_condition)
              .or(exclude_products_condition)
          )
      end

      def price_condition
        price_range = janpara_crawl_setting.min_price..janpara_crawl_setting.max_price
        JanparaProduct.where.not(price: price_range)
      end

      def required_keywords_condition
        return JanparaProduct.none if required_keywords.blank?

        required_keywords.map do |required_keyword|
          JanparaProduct.where.not("name LIKE ?", "%#{required_keyword}%")
        end.reduce(&:or)
      end

      def exclude_keywords_condition
        return JanparaProduct.none if exclude_keywords.blank?

        exclude_keywords.map do |exclude_keyword|
          JanparaProduct.where("name LIKE ?", "%#{exclude_keyword}%")
        end.reduce(&:or)
      end

      def exclude_products_condition
        return JanparaProduct.none if exclude_products.blank?

        exclude_products.map do |exclude_product|
          JanparaProduct.where(external_id: exclude_product)
        end.reduce(&:or)
      end

      def required_keywords
        @required_keywords ||=
          janpara_crawl_setting
          .janpara_crawl_setting_required_keywords
          .pluck(:keyword)
          .map { |keyword| normalize_keyword(keyword) }
      end

      def exclude_keywords
        @exclude_keywords ||=
          janpara_crawl_setting
          .janpara_crawl_setting_exclude_keywords
          .pluck(:keyword)
          .map { |keyword| normalize_keyword(keyword) }
      end

      def normalize_keyword(keyword)
        keyword.tr("Ａ-Ｚ０-９", "A-Z0-9").downcase
      end

      def exclude_products
        @exclude_products ||=
          janpara_crawl_setting
          .janpara_crawl_setting_exclude_products
          .pluck(:external_id)
      end

      def janpara_crawl_setting
        @janpara_crawl_setting ||= product.janpara_crawl_setting
      end
    end
  end
end
