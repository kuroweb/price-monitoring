module Crawl
  class Proxy
    def self.get
      proxy = ENV.fetch("PROXY_LIST").split(",").sample
      host, port, username, password = proxy.split(":")

      { server: "#{host}:#{port}", username:, password: }
    end
  end
end
