module Crawl
  module Janpara
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
        JanparaProduct
          .where(product_id: product.id)
          .merge(
            price_condition
              .or(required_keywords_condition)
              .or(exclude_keywords_conditon)
          )
      end

      def price_condition
        price_range = product.janpara_crawl_setting.min_price..product.janpara_crawl_setting.max_price
        JanparaProduct.where.not(price: price_range)
      end

      def required_keywords_condition
        return JanparaProduct.none if required_keywords.blank?

        required_keywords.map do |required_keyword|
          JanparaProduct.where.not("name LIKE ?", "%#{required_keyword}%")
        end.reduce(&:or)
      end

      def exclude_keywords_conditon
        return JanparaProduct.none if exclude_keywords.blank?

        exclude_keywords.map do |exclude_keyword|
          JanparaProduct.where("name LIKE ?", "%#{exclude_keyword}%")
        end.reduce(&:or)
      end

      def required_keywords
        @required_keywords ||=
          product.janpara_crawl_setting
                 .janpara_crawl_setting_required_keywords
                 .pluck(:keyword)
                 .map { |keyword| normalize_keyword(keyword) }
      end

      def exclude_keywords
        @exclude_keywords ||=
          product.janpara_crawl_setting
                 .janpara_crawl_setting_exclude_keywords
                 .pluck(:keyword)
                 .map { |keyword| normalize_keyword(keyword) }
      end

      def normalize_keyword(keyword)
        keyword.tr("Ａ-Ｚ０-９", "A-Z0-9").downcase
      end
    end
  end
end
