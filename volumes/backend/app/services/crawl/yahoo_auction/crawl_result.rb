# クロール結果クラス
module Crawl
  module YahooAuction
    class CrawlResult
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :platform, :string
      attribute :external_id, :string
      attribute :seller_id, :string
      attribute :name, :string
      attribute :price, :integer
      attribute :buyout_price, :integer
      attribute :thumbnail_url, :string
      attribute :published, :boolean
      attribute :bought_date, :datetime
      attribute :end_date, :datetime

      validates :platform, inclusion: { in: %w[yahoo_auction yahoo_fleamarket] }
      validates :published, inclusion: { in: [true, false] }
      validates_presence_of :external_id, :seller_id, :name, :price, :thumbnail_url
    end
  end
end
