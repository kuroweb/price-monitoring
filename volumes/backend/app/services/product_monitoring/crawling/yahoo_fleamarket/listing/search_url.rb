module ProductMonitoring
  module Crawling
    module YahooFleamarket
      module Listing
        module SearchUrl
          HOST = "paypayfleamarket.yahoo.co.jp".freeze
          PATH = %r{\A/search/[^/]+\z}
          PLATFORM = "yahoo_fleamarket".freeze

          def self.build(keyword)
            ["https://#{HOST}/search/#{URI.encode_www_form_component(keyword).gsub('+', '%20')}"]
          end

          def self.validate(uri)
            keyword = URI::DEFAULT_PARSER.unescape(uri.path.delete_prefix("/search/"))
            raise ArgumentError, "Yahoo!フリマの検索語を入力してください" if keyword.blank?
            raise ArgumentError, "Yahoo!フリマの検索語には / と制御文字を使用できません" if keyword.match?(%r{[/\x00-\x1f\x7f]})
          end
        end
      end
    end
  end
end
