module ProductMonitoring
  # 価格帯・必須語・除外語・除外出品IDに一致しない理由を返す。空なら採用する
  class Filter
    def self.call(...)
      new(...).call
    end

    def initialize(item:, params:)
      @item = item
      @params = params
    end

    def call
      reasons = price_reasons + keyword_reasons
      reasons << "excluded_listing" if Array(params[:exclude_external_ids]).include?(item[:external_id])
      reasons
    end

    private

    attr_reader :item, :params

    def price_reasons
      reasons = []
      price = item[:price]
      min = params[:min_price]
      max = params[:max_price]
      reasons << "below_min_price" if min && (price.nil? || price < min.to_i)
      reasons << "above_max_price" if max && (price.nil? || price > max.to_i)
      reasons
    end

    def keyword_reasons
      reasons = []
      name = normalize(item[:name])
      required = keywords(:required_keywords)
      reasons << "missing_required_keyword" unless required.all? { |word| name.include?(word) }
      excluded = keywords(:exclude_keywords)
      reasons << "excluded_keyword" if excluded.any? { |word| name.include?(word) }
      reasons
    end

    def keywords(key)
      Array(params[key]).map { |word| normalize(word) }.reject(&:empty?)
    end

    # 全角半角・大文字小文字・空白の有無を区別せずに比べる
    def normalize(value)
      value.to_s.unicode_normalize(:nfkc).downcase.gsub(/[[:space:]]+/, "")
    end
  end
end
