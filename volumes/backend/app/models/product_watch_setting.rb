class ProductWatchSetting < ApplicationRecord
  %i[required_keywords exclude_keywords].each do |name|
    attribute name, default: -> { [] }
  end

  validates :name, presence: true
end
