module Search
  class RelatedProduct
    RELATED_TYPES = %w[mercari yahoo_auction].freeze

    attr_reader :related_type, :product_id, :external_id, :name, :price, :thumbnail_url,
                :published, :bought_date, :created_at, :updated_at

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value) if assignable?(key, value)
      end
    end

    def assignable?(key, value)
      return false if key == :related_type && RELATED_TYPES.exclude?(value)

      true
    end
  end
end
