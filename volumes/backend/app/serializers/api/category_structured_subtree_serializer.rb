module Api
  class CategoryStructuredSubtreeSerializer
    def initialize(category)
      @category = category
    end

    def as_json(_opts = {})
      {
        **category.as_json.symbolize_keys,
        parent:,
        children: serialize_children(category)
      }
    end

    private

    attr_reader :category

    def parent
      category.parent
    end

    def serialize_children(category)
      category.children.map { |child| serialize(child) }
    end

    def serialize(category)
      {
        **category.as_json.symbolize_keys,
        children: serialize_children(category)
      }
    end
  end
end
