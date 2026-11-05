module Crawl::Search
  # 価格帯・必須語・除外語・除外出品IDに一致しない理由を返す。空なら採用する
  class Filter
    def self.call(item:, params:)
      reasons = []
      price = item[:price]
      reasons << "below_min_price" if params[:min_price] && (price.nil? || price < params[:min_price].to_i)
      reasons << "above_max_price" if params[:max_price] && (price.nil? || price > params[:max_price].to_i)
      name = item[:name].to_s.downcase
      required = Array(params[:required_keywords]).map(&:to_s).reject(&:empty?)
      reasons << "missing_required_keyword" unless required.all? { |word| name.include?(word.downcase) }
      excluded = Array(params[:exclude_keywords]).map(&:to_s).reject(&:empty?)
      reasons << "excluded_keyword" if excluded.any? { |word| name.include?(word.downcase) }
      reasons << "excluded_listing" if Array(params[:exclude_external_ids]).include?(item[:external_id])
      reasons
    end
  end
end
