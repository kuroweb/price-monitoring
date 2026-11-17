module ProductMonitoring
  module Crawling
    module TreasureFactory
      module ListPage
        module SearchUrl
          HOST = "ec.treasure-f.com".freeze
          PATH = %r{\A/search/?\z}
          PLATFORM = "treasure_factory".freeze

          def self.build(keyword)
            ["https://#{HOST}/search?#{URI.encode_www_form(word: keyword)}"]
          end

          def self.validate(uri)
            raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
          end
        end
      end
    end
  end
end
