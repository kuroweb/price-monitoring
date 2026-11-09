class ProductWatchSetting < ApplicationRecord
  has_many :product_aggregation_results, dependent: :destroy
  %i[required_keywords exclude_keywords].each do |name|
    attribute name, default: -> { [] }
  end

  validates :name, presence: true
end
