module Categories
  class Creator
    def self.call(...)
      new(...).call
    end

    def initialize(params:)
      @parent_id = params[:parent_id]
      @name = params[:name]
    end

    def call
      parent_category = Category.find_by(id: parent_id)

      if parent_category
        parent_category.children.create!(name:)
      else
        Category.create!(name:)
      end
    end

    private

    attr_reader :parent_id, :name
  end
end
