module Categories
  class Updater
    def self.call(...)
      new(...).call
    end

    def initialize(category:, params:)
      @category = category
      @has_parent_id_param = params.key?(:parent_id)
      @parent_id = params[:parent_id]
      @name = params[:name]
    end

    def call
      category.update!(name:, parent_id: resolved_parent_id)
    end

    private

    attr_reader :category, :parent_id, :name, :has_parent_id_param

    def resolved_parent_id
      return category.parent_id unless has_parent_id_param
      return nil if parent_id.blank?

      id = Integer(parent_id, exception: false)
      return nil if id.blank? || id.zero?

      Category.find(id).id
    end
  end
end
