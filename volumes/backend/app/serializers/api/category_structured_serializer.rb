module Api
  class CategoryStructuredSerializer
    def initialize(categories, display_depth_limit)
      @categories = categories
      @display_depth_limit = display_depth_limit.to_i
    end

    def as_json(_opts = {})
      categories.map { |category| serialize(category) }
    end

    private

    attr_reader :categories, :display_depth_limit

    def serialize(category)
      {
        **category.as_json.symbolize_keys,
        children: children(category)
      }
    end

    def children(category)
      return [] if depth_exceeded?(category)

      category.children.map { |child| serialize(child) }
    end

    def depth_exceeded?(category)
      display_depth_limit.zero? ||
        category.depth >= display_depth_limit ||
        category.depth >= Category::DEPTH_LIMIT
    end
  end
end
