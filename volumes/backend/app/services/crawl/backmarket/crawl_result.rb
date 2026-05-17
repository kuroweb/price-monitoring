module Crawl
  module Backmarket
    class CrawlResult
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, :string
      attribute :price, :integer
      attribute :condition, :string
      attribute :memory, :string
      attribute :storage, :string
      attribute :cpu, :string
      attribute :stock_status, :string

      validates_presence_of :name, :memory, :storage, :cpu, :stock_status
      validates :stock_status, inclusion: { in: %w[in_stock out_of_stock] }
      validate :validate_in_stock_fields

      private

      def validate_in_stock_fields
        return unless stock_status == "in_stock"

        errors.add(:price, "can't be blank") if price.blank?
        errors.add(:condition, "can't be blank") if condition.blank?
      end
    end
  end
end
