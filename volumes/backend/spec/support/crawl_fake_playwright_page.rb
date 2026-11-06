# frozen_string_literal: true

require_relative "playwright_css_compat"

class CrawlFakePlaywrightPage
  class Element
    def initialize(node, clicks = [])
      @node = node
      @clicks = clicks
    end

    def query_selector(selector)
      node = PlaywrightCssCompat.query_nodes(@node, selector).first
      node ? self.class.new(node, @clicks) : nil
    end

    def query_selector_all(selector)
      PlaywrightCssCompat.query_nodes(@node, selector).map { |n| self.class.new(n, @clicks) }
    end

    def click
      @clicks << @node["data-testid"]
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

  attr_reader :goto_urls, :goto_options, :mouse, :clicks, :wait_for_function_calls
  attr_accessor :response_status

  def initialize(html)
    @doc = Nokogiri::HTML(html)
    @goto_urls = []
    @goto_options = []
    @mouse = Mouse.new
    @clicks = []
    @wait_for_function_calls = []
  end

  def query_selector(selector)
    node = PlaywrightCssCompat.query_nodes(@doc, selector).first
    node ? Element.new(node, @clicks) : nil
  end

  def query_selector_all(selector)
    PlaywrightCssCompat.query_nodes(@doc, selector).map { |n| Element.new(n, @clicks) }
  end

  def reload; end

  def wait_for_function(*args, **options)
    @wait_for_function_calls << [args, options]
  end

  def goto(url, **options)
    @goto_urls << url
    @goto_options << options
    Struct.new(:status).new(response_status) if response_status
  end

  def eval_on_selector(selector, _javascript)
    node = @doc.at_css(selector)
    node&.text
  end
end
