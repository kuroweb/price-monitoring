module ProductMonitoring
  module Crawling
    module Mercari
      module ListPage
        class SellerIds
          HOST = "api.mercari.jp".freeze
          PATH = "/v2/entities:search".freeze
          MAX_RESPONSE_BYTES = 10 * 1024 * 1024

          # イベントはブラウザとの通信のスレッドで呼ばれるので、ここでは応答を選ぶだけにして本文は call で読む
          def self.observe(page)
            new.tap { |seller_ids| page.on("response", ->(response) { seller_ids.add(response) }) }
          end

          def initialize
            @responses = []
          end

          def add(response)
            @responses << response if search_api?(response)
          end

          def call
            pairs = @responses.flat_map do |response|
              items(response).filter_map { |item| [item["id"], item["sellerId"]] if item.is_a?(Hash) }
            end
            SellerIdMap.build(pairs)
          end

          private

          def search_api?(response)
            uri = URI.parse(response.url)
            uri.scheme == "https" && uri.host == HOST && uri.path == PATH
          rescue URI::InvalidURIError
            false
          end

          def items(response)
            return [] unless response.status == 200

            body = response.body
            return [] if body.bytesize > MAX_RESPONSE_BYTES

            items = JSON.parse(body)["items"]
            items.is_a?(Array) ? items : []
          rescue StandardError => e
            # 本文の一部がメッセージに入ることがあるので、例外の種類だけを出す
            Rails.logger.warn("Mercari seller ids unavailable: #{e.class}")
            []
          end
        end
      end
    end
  end
end
