# frozen_string_literal: true

module PlaywrightCssCompat
  module_function

  def query_nodes(scope, selector)
    selector = selector.strip
    if selector.include?(" >> ")
      chain, playwright = selector.split(" >> ", 2)
      nodes = css_nodes(scope, chain)
      return text_match_nodes(nodes, playwright)
    end

    return text_match_nodes(css_nodes(scope, "*"), selector) if selector.start_with?("text=")

    expand_has(scope, selector)
  end

  def css_nodes(scope, selector)
    scope.css(selector).to_a
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
end
