# frozen_string_literal: true

module PlaywrightCssCompat
  module_function

  def query_nodes(scope, selector)
    selector = selector.strip
    if selector.include?(" >> ")
      chain, playwright = selector.split(" >> ", 2)
      return filter_playwright_nodes(css_nodes(scope, chain), playwright)
    end

    simple_selector_nodes(scope, selector)
  end

  def simple_selector_nodes(scope, selector)
    return text_match_nodes(css_nodes(scope, "*"), selector) if selector.start_with?("text=")
    return xpath_nodes(scope, selector) if selector.start_with?("xpath=")

    if (match = has_text_selector_match(selector))
      return has_text_nodes(scope, match[:tag], match[:text])
    end

    expand_has(scope, selector)
  end

  def xpath_nodes(scope, selector)
    node = scope.at_xpath(selector.delete_prefix("xpath="))
    node ? [node] : []
  end

  def css_nodes(scope, selector)
    scope.css(selector).to_a
  end

  def filter_playwright_nodes(nodes, playwright_selector)
    playwright_selector = playwright_selector.strip
    return text_match_nodes(nodes, playwright_selector) if playwright_selector.start_with?("text=")

    if (match = has_text_only_match(playwright_selector))
      return nodes.select { |node| node.text.include?(match) }
    end

    text_match_nodes(nodes, playwright_selector)
  end

  def text_match_nodes(nodes, playwright_selector)
    text = playwright_text(playwright_selector)
    nodes.select { |node| node.text.strip == text }
  end

  def playwright_text(selector)
    text = selector.delete_prefix("text=").strip
    text.start_with?('"', "'") ? text[1..-2] : text
  end

  def expand_has(scope, selector)
    match = selector.match(/\A(.+?):has\((.+)\)\z/)
    return css_nodes(scope, selector) unless match

    base_selector = match[1]
    inner_selector = match[2]
    css_nodes(scope, base_selector).select { |node| node.at_css(inner_selector) }
  end

  def has_text_selector_match(selector)
    match = selector.match(/\A(\w+):has-text\('(.+)'\)\z/)
    return nil unless match

    { tag: match[1], text: match[2] }
  end

  def has_text_only_match(selector)
    match = selector.match(/\A:has-text\('(.+)'\)\z/)
    match&.[](1)
  end

  def has_text_nodes(scope, tag, text)
    css_nodes(scope, tag).select { |node| node.text.include?(text) }
  end
end
