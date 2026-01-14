module Api
  class CategoryStructuredSerializer
    def initialize(categories)
      @categories = categories
    end

    def as_json(_opts = {})
      categories.map { |category| serialize(category) }
    end

    private

    attr_reader :categories

    def serialize(category)
      {
        **category.as_json.symbolize_keys,
        children: category.children.map { |child| serialize(child) }
      }
    end
  end
end
