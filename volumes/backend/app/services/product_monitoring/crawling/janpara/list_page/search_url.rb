module ProductMonitoring
  module Crawling
    module Janpara
      module ListPage
        module SearchUrl
          HOST = "www.janpara.co.jp".freeze
          PATH = %r{\A/sale/search/result/\z}
          PLATFORM = "janpara".freeze

          def self.build(keyword)
            ["https://#{HOST}/sale/search/result/?#{URI.encode_www_form(KEYWORDS: keyword)}"]
          end

          def self.validate(uri)
            keywords = URI.decode_www_form(uri.query.to_s).filter_map { |key, value| value if key == "KEYWORDS" }
            raise ArgumentError, "KEYWORDS is required" unless keywords.any? { |value| value.strip.present? }
          end
        end
      end
    end
  end
end
