module Categories
  class Updater
    def self.call(...)
      new(...).call
    end

    def initialize(category:, params:)
      @category = category
      @parent_id = params[:parent_id]
      @name = params[:name]
    end

    def call
      category.update!(name:, parent_id:)
    end

    private

    attr_reader :category, :parent_id, :name
  end
end
