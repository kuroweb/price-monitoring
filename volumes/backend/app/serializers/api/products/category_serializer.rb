module Api
  module Products
    class CategorySerializer < BaseSerializer
      def initialize(category)
        @category = category
      end

      private

      def json
        @category.as_json
      end
    end
  end
end
