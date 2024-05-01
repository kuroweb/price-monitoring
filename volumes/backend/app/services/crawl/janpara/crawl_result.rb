module Crawl
  module Janpara
    class CrawlResult
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :janpara_id, :string
      attribute :name, :string
      attribute :price, :integer
      attribute :thumbnail_url, :string

      validates_presence_of :janpara_id, :name, :price, :thumbnail_url
    end
  end
end
