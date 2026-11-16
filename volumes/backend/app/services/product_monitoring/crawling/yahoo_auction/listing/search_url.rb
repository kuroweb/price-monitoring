module ProductMonitoring
  module Crawling
    module YahooAuction
      module Listing
        module SearchUrl
          HOST = "auctions.yahoo.co.jp".freeze
          PATH = %r{\A/(?:search/search|closedsearch/closedsearch)\z}
          PLATFORM = "yahoo_auction".freeze

          def self.build(keyword)
            query = URI.encode_www_form(p: keyword)
            ["https://#{HOST}/search/search?#{query}", "https://#{HOST}/closedsearch/closedsearch?#{query}"]
          end

          def self.validate(uri)
            raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
          end
        end
      end
    end
  end
end
