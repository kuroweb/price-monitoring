module Crawl
  module UsedSofmap
    class CrawlResult
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :external_id, :string
      attribute :name, :string
      attribute :price, :integer
      attribute :thumbnail_url, :string

      validates_presence_of :external_id, :name, :price, :thumbnail_url
    end
  end
end
