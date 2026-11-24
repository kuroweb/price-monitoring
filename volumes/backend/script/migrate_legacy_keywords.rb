# Count legacy keyword strings without writing:
#   bin/rails runner script/migrate_legacy_keywords.rb
# Convert one verified legacy keyword string; provide its exact JSON string on stdin:
#   bin/rails runner script/migrate_legacy_keywords.rb apply TABLE ID COLUMN < verified-keywords.json
usage = "Usage: bin/rails runner script/migrate_legacy_keywords.rb [apply TABLE ID COLUMN < verified-keywords.json]"
models = [ProductMonitoring::CrawlSetting, ProductMonitoring::Monitor].index_by(&:table_name)
columns = %w[required_keywords negative_keywords]

if ARGV.empty?
  models.each do |table, model|
    columns.each do |column|
      quoted_column = model.lease_connection.quote_column_name(column)
      count = model.where("JSON_TYPE(#{quoted_column}) = ?", "STRING").count
      puts "#{table}.#{column}: #{count} candidate(s)"
    end
  end
elsif ARGV.size == 4 && ARGV.first == "apply"
  _, table, id, column = ARGV
  model = models[table]
  valid_target = model && columns.include?(column) && id.match?(/\A[1-9]\d*\z/)
  abort "Specify a target table, positive id and keyword column" unless valid_target

  begin
    original = JSON.parse($stdin.read)
  rescue JSON::ParserError
    abort "Provide the verified value as a JSON string"
  end
  valid_original = original.is_a?(String) && original.match?(/[\n,、]/)
  abort "Provide the original JSON string with a legacy delimiter" unless valid_original

  # Reproduce the old frontend parser, including String.trim and deduplication.
  trim_chars = /\A[\p{Zs}\t-\r  ﻿]+|[\p{Zs}\t-\r  ﻿]+\z/
  words = original.split(/[\n,、]/).map { |word| word.gsub(trim_chars, "") }.reject(&:empty?).uniq
  valid_words = words.size <= 50 && words.all? { |word| word.length <= 255 }
  abort "Legacy keywords are outside the supported range" unless valid_words

  message = model.transaction do
    setting = model.lock.find(id)
    current = setting.public_send(column)
    next "Already converted" if current == words

    abort "Current value differs from the verified legacy string" unless current == original
    # The row is locked, so the verified value cannot change before this write.
    raise "Failed to convert keyword column" unless setting.update_column(column, words) # rubocop:disable Rails/SkipsModelValidations

    "Converted one keyword column"
  end
  puts message
else
  abort usage
end
