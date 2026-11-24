# Convert keywords saved as legacy comma-separated JSON strings into keyword arrays.
#   bin/rails runner script/migrate_legacy_keywords.rb
columns = %w[required_keywords negative_keywords]

[ProductMonitoring::CrawlSetting, ProductMonitoring::Monitor].each do |model|
  columns.each do |column|
    quoted_column = model.lease_connection.quote_column_name(column)
    records = model.where("JSON_TYPE(#{quoted_column}) = ?", "STRING")
    count = records.count
    records.find_each do |record|
      words = record.public_send(column).split(/[\n,、]/).map { |word| word.gsub(/\A[[:space:]]+|[[:space:]]+\z/, "") }
      record.update_column(column, words.reject(&:empty?)) # rubocop:disable Rails/SkipsModelValidations
    end
    puts "#{model.table_name}.#{column}: #{count} updated"
  end
end
