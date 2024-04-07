module Search
  class RelatedProduct
    attr_reader :related_type, :product_id, :external_id, :name, :price, :thumbnail_url,
                :published, :bought_date, :created_at, :updated_at

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key)
      end
    end
  end
end
