module Crawl
  class Proxy
    def self.get
      proxy = ENV.fetch("PROXY_LIST").split(/\R/).sample
      host, port, username, password = proxy.split(":")

      ["#{host}:#{port}", username, password]
    end
  end
end
