module ProductMonitoring
  module Sites
    module Pagination
      def self.increment(uri, key:, default:, step:, minimum: nil)
        query = URI.decode_www_form(uri.query)
        current = query.to_h.fetch(key, default).to_i
        query.reject! { |name, _| name == key }
        value = current + step
        value = [value, minimum].max if minimum
        query << [key, value.to_s]
        uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query) }
      end
    end
  end
end
