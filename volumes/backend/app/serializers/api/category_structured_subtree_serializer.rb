module Api
  class CategoryStructuredSubtreeSerializer
    def initialize(category, display_depth_limit)
      @category = category
      @display_depth_limit = display_depth_limit.to_i
    end

    def as_json(_opts = {})
      {
        **category.as_json.symbolize_keys,
        parent:,
        children: children(category)
      }
    end

    private

    attr_reader :category, :display_depth_limit

    def parent
      category.parent
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

    def serialize(category)
      {
        **category.as_json.symbolize_keys,
        children: children(category)
      }
    end
  end
end
