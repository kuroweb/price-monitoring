module Api
  class CategoryListSerializer
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
      CategoryDetailSerializer.new(category, display_depth_limit).as_json
    end
  end
end
