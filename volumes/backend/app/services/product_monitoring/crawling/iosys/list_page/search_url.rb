module ProductMonitoring
  module Crawling
    module Iosys
      module ListPage
        module SearchUrl
          HOST = "iosys.co.jp".freeze
          PATH = %r{\A/items/?\z}
          PLATFORM = "iosys".freeze

          def self.build(keyword)
            ["https://#{HOST}/items?#{URI.encode_www_form(q: keyword)}"]
          end

          def self.validate(uri)
            raise ArgumentError, "URL query is required" if uri.query.to_s.empty?

            return unless URI.decode_www_form(uri.query).any? { |key, value| key == "t" && value == "g" }

            raise ArgumentError, "イオシスは個別出品の検索URL（t=gなし）を指定してください"
          end
        end
      end
    end
  end
end
