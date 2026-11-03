module Products
  class SearchSettingsWriter
    def self.call(product:, params:)
      values = Crawl::Search::Input.call(params: params, require_name: true)
      canonical = values[:urls].map { |row| Crawl::Search::UrlRouter.call(url: row[:url])[:canonical_url] }
      raise ArgumentError, "同じURLが重複しています" if canonical.uniq.size != canonical.size

      Product.transaction do
        product.lock! if product.persisted?
        product.assign_attributes(values.slice(:name, :enabled, :min_price, :max_price))
        product.save!
        %i[search_urls required_keywords exclude_keywords excluded_listings].each do |key|
          product.public_send(key).delete_all
          product.association(key).reset
        end
        values[:urls].each { |row| product.search_urls.create!(row.slice(:url, :enabled)) }
        %i[required_keywords exclude_keywords].each do |key|
          values[key].each { |word| product.public_send(key).create!(keyword: word) }
        end
        values[:excluded_listings].each { |row| product.excluded_listings.create!(row) }
      end
      product
    end
  end
end
