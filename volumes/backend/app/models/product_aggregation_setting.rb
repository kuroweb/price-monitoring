class ProductAggregationSetting < ApplicationRecord
  # DBの式による既定値は保存前のオブジェクトに反映されないため、モデルでも空配列にする
  %i[required_keywords exclude_keywords].each do |name|
    attribute name, default: -> { [] }
  end

  ## associations ##
  has_many :product_aggregation_results, dependent: :destroy

  ## validations ##
  validates :name, presence: true

  ## scopes ##

  ## methods ##
end
