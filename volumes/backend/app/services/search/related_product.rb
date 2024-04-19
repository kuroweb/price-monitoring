module Search
  class RelatedProduct
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :platform, :string
    attribute :product_id, :integer
    attribute :external_id, :string
    attribute :name, :string
    attribute :price, :integer
    attribute :buyout_price, :integer
    attribute :thumbnail_url, :string
    attribute :published, :boolean
    attribute :bought_date, :datetime
    attribute :end_date, :datetime
    attribute :created_at, :datetime
    attribute :updated_at, :datetime

    validates :published, inclusion: { in: [true, false] }
    validates_presence_of :platform, :product_id, :external_id, :name, :price, :thumbnail_url, :created_at, :updated_at
  end
end
