module Crawl
  class BackmarketClient
    PYTHON_COMMAND = ENV.fetch("CURL_CFFI_PYTHON_COMMAND").freeze
    TIMEOUT_SECONDS = 10
    IMPERSONATE = "chrome124".freeze
    PROXY_INVALIDATION_STATUS_CODES = [403, 429].freeze
    HEADERS = {
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Language" => "ja,en-US;q=0.9,en;q=0.8"
    }.freeze

    class << self
      def get(url:)
        payload = execute_python(url:)
        raise RequestError, payload.fetch("error") if payload["error"].present?

        Response.new(
          status: payload.fetch("status"),
          url: payload.fetch("url"),
          headers: payload.fetch("headers"),
          body: payload.fetch("body")
        )
      end

      private

      def execute_python(url:)
        proxy = Crawl::DynamicProxy.get
        env = python_env(url:, proxy:)

        stdout, stderr, process_status = Open3.capture3(env, PYTHON_COMMAND, "-c", python_script)
        payload = JSON.parse(stdout)

        validate_dependency_availability!(stderr)
        validate_command_status!(process_status, stderr)
        proxy_invalidation!(payload:, proxy:)

        payload
      rescue JSON::ParserError => e
        raise RequestError, "Failed to parse curl_cffi response: #{e.message}"
      end

      def python_env(url:, proxy:)
        {
          "TARGET_URL" => url,
          "IMPERSONATE" => IMPERSONATE,
          "TIMEOUT_SECONDS" => TIMEOUT_SECONDS.to_s,
          "HEADERS_JSON" => HEADERS.to_json,
          "PROXY_URL" => proxy_url(proxy).to_s
        }
      end

      def validate_dependency_availability!(stderr)
        return unless stderr.include?("No module named 'curl_cffi'")

        raise DependencyError, "curl_cffi is not installed."
      end

      def validate_command_status!(process_status, stderr)
        raise RequestError, stderr unless process_status.success?
      end

      def proxy_url(proxy)
        credentials = "#{proxy[:username]}:#{proxy[:password]}@"
        "http://#{credentials}#{proxy[:server]}"
      end

      def proxy_invalidation!(payload:, proxy:)
        return unless PROXY_INVALIDATION_STATUS_CODES.include?(payload["status"].to_i)

        Crawl::DynamicProxy.remove(proxy:)
      end

      def python_script
        <<~PYTHON
          import json
          import os
          from curl_cffi import requests

          url = os.environ["TARGET_URL"]
          impersonate = os.environ["IMPERSONATE"]
          timeout_seconds = int(os.environ["TIMEOUT_SECONDS"])
          headers = json.loads(os.environ["HEADERS_JSON"])
          proxy_url = os.environ.get("PROXY_URL")

          try:
            request_options = {
              "impersonate": impersonate,
              "headers": headers,
              "timeout": timeout_seconds,
              "allow_redirects": True
            }

            if proxy_url:
              request_options["proxies"] = {"http": proxy_url, "https": proxy_url}

            response = requests.get(url, **request_options)
            print(json.dumps({
              "status": response.status_code,
              "url": response.url,
              "headers": dict(response.headers),
              "body": response.text
            }))
          except Exception as e:
            print(json.dumps({"error": str(e)}))
        PYTHON
      end
    end

    class Response
      attr_reader :status, :url, :headers, :body

      def initialize(status:, url:, headers:, body:)
        @status = status
        @url = url
        @headers = headers
        @body = body
      end

      def success?
        status.to_i.between?(200, 299)
      end
    end

    class Error < StandardError; end
    class DependencyError < Error; end
    class RequestError < Error; end
  end
end
