module ProductMonitoring
  module Crawling
    module Mercari
      module ListPage
        module SearchUrl
          HOST = "jp.mercari.com".freeze
          PATH = %r{\A/search\z}
          PLATFORM = "mercari".freeze

          def self.build(keyword)
            ["https://#{HOST}/search?#{URI.encode_www_form(keyword: keyword)}"]
          end

          def self.validate(uri)
            raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
          end
        end
      end
    end
  end
end
