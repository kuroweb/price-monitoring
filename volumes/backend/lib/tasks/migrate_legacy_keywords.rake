models = -> { [ProductMonitoring::CrawlSetting, ProductMonitoring::Monitor].index_by(&:table_name) }
columns = %w[required_keywords negative_keywords]

namespace :product_monitoring do
  desc "Count JSON string values in product monitoring keyword columns without writing"
  task migrate_legacy_keywords: :environment do
    models.call.each do |table, model|
      columns.each do |column|
        quoted_column = model.lease_connection.quote_column_name(column)
        count = model.where("JSON_TYPE(#{quoted_column}) = ?", "STRING").count
        puts "#{table}.#{column}: #{count} candidate(s)"
      end
    end
  end
end

namespace "product_monitoring:migrate_legacy_keywords" do
  desc "Convert one verified legacy keyword string; provide its exact JSON string on stdin"
  task :apply, %i[table id column] => :environment do |_task, args|
    model = models.call[args[:table]]
    column = args[:column]
    valid_target = model && columns.include?(column) && args[:id].to_s.match?(/\A[1-9]\d*\z/)
    abort "Specify a target table, positive id and keyword column" unless valid_target

    original = JSON.parse($stdin.read)
    valid_original = original.is_a?(String) && original.match?(/[\n,、]/)
    abort "Provide the original JSON string with a legacy delimiter" unless valid_original

    # Reproduce the old frontend parser, including String.trim and deduplication.
    trim_chars = /\A[\p{Zs}\t-\r\u2028\u2029\ufeff]+|[\p{Zs}\t-\r\u2028\u2029\ufeff]+\z/
    words = original.split(/[\n,、]/).map { |word| word.gsub(trim_chars, "") }.reject(&:empty?).uniq
    valid_words = words.size <= 50 && words.all? { |word| word.length <= 255 }
    abort "Legacy keywords are outside the supported range" unless valid_words

    message = model.transaction do
      setting = model.lock.find(args[:id])
      current = setting.public_send(column)
      next "Already converted" if current == words

      abort "Current value differs from the verified legacy string" unless current == original
      # The row is locked, so the verified value cannot change before this write.
      raise "Failed to convert keyword column" unless setting.update_column(column, words) # rubocop:disable Rails/SkipsModelValidations

      "Converted one keyword column"
    end
    puts message
  rescue JSON::ParserError
    abort "Provide the verified value as a JSON string"
  end
end
