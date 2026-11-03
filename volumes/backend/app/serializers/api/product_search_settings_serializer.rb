module Api
  class ProductSearchSettingsSerializer
    def initialize(product); @product = product; end
    def as_json(*)
      @product.attributes.slice("id", "name", "enabled", "min_price", "max_price").symbolize_keys.merge(
        required_keywords: @product.required_keywords.pluck(:keyword), exclude_keywords: @product.exclude_keywords.pluck(:keyword),
        excluded_listings: @product.excluded_listings.map { |x| { platform: x.platform, external_id: x.external_id } },
        urls: @product.search_urls.map { |x| { url: x.url, enabled: x.enabled } }
      )
    end
  end
end
