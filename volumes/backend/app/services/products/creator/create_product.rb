module Products
  module Creator
    class CreateProduct
      PRODUCT_ATTRIBUTES = %i[name].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(params: {})
        @params = params
      end

      def call
        ApplicationRecord.transaction do
          product = create_product
          create_category_association(product)

          product
        end
      end

      private

      attr_reader :params

      def create_product
        attributes = params.slice(*PRODUCT_ATTRIBUTES) || {}
        Product.create!(attributes)
      end

      def create_category_association(product)
        return if params[:category_id].blank?

        category = Category.find(params[:category_id])
        product.category = category
      end
    end
  end
end
