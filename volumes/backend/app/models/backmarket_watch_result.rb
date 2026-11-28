class BackmarketWatchResult < ApplicationRecord
  IN_STOCK_REQUIRED_FIELDS = %i[price condition memory storage cpu].freeze

  belongs_to :backmarket_watch_target

  validates :name, :stock_status, :crawled_at, presence: true
  validates :stock_status, inclusion: { in: %w[in_stock out_of_stock] }
  validate :validate_in_stock_fields

  private

  def validate_in_stock_fields
    return unless stock_status == "in_stock"

    IN_STOCK_REQUIRED_FIELDS.each do |field|
      errors.add(field, "can't be blank") if public_send(field).blank?
    end
  end
end
