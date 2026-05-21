module Crawl
  module Backmarket
    class CrawlResult
      IN_STOCK_REQUIRED_FIELDS = %i[price condition memory storage cpu].freeze

      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, :string
      attribute :price, :integer
      attribute :condition, :string
      attribute :memory, :string
      attribute :storage, :string
      attribute :cpu, :string
      attribute :stock_status, :string

      validates_presence_of :name, :stock_status
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
  end
end
