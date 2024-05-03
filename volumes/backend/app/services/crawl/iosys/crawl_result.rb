module Crawl
  module Iosys
    class CrawlResult
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :iosys_id, :string
      attribute :name, :string
      attribute :price, :integer
      attribute :thumbnail_url, :string

      validates_presence_of :iosys_id, :name, :price, :thumbnail_url
    end
  end
end
