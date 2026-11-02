# frozen_string_literal: true

class CrawlFakePlaywrightPage
  class Element
    def initialize(node)
      @node = node
    end

    def query_selector(selector)
      node = @node.at_css(selector)
      node ? self.class.new(node) : nil
    end

    def query_selector_all(selector)
      @node.css(selector).map { |n| self.class.new(n) }
    end

    def get_attribute(name)
      @node[name]
    end

    def inner_text
      @node.text.strip
    end
  end

  class Mouse
    def wheel(*); end
  end

  attr_reader :goto_urls, :mouse

  def initialize(html)
    @doc = Nokogiri::HTML(html)
    @goto_urls = []
    @mouse = Mouse.new
  end

  def query_selector(selector)
    node = @doc.at_css(selector)
    node ? Element.new(node) : nil
  end

  def goto(url)
    @goto_urls << url
  end
end
