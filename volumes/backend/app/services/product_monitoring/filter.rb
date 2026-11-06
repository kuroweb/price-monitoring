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
      reasons << "below_min_price" if params[:min_price] && (price.nil? || price < params[:min_price].to_i)
      reasons << "above_max_price" if params[:max_price] && (price.nil? || price > params[:max_price].to_i)
      reasons
    end

    def keyword_reasons
      reasons = []
      name = item[:name].to_s.downcase
      required = keywords(:required_keywords)
      reasons << "missing_required_keyword" unless required.all? { |word| name.include?(word.downcase) }
      excluded = keywords(:exclude_keywords)
      reasons << "excluded_keyword" if excluded.any? { |word| name.include?(word.downcase) }
      reasons
    end

    def keywords(key)
      Array(params[key]).map(&:to_s).reject(&:empty?)
    end
  end
end
